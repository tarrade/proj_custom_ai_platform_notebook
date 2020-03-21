const { IncomingWebhook } = require('@slack/webhook');
const {BigQuery} = require('@google-cloud/bigquery');

// Get parameters from env variables
const project_list =process.env.PROJECT_LIST.split(',');
const dataset = process.env.DATASET;
const table = process.env.TABLE;
const billing_project = process.env.PROJECT;

// Webhook for Slack
const url = process.env.SLACK_WEBHOOK_URL;
const webhook = new IncomingWebhook(url);

// subscribeSlack is the main function called by Cloud Functions.
module.exports.subscribeSlack= (pubSubEvent, context) => {
  const pubsubdata = eventToBuild(pubSubEvent.data);

  if (project_list.indexOf(pubsubdata.budgetDisplayName) === -1) {
    console.log(`skip project: ${pubsubdata.budgetDisplayName.substr(0,pubsubdata.budgetDisplayName.indexOf(' '))}`);
    return;
  }
  console.log(`project: ${pubsubdata.budgetDisplayName.substr(0,pubsubdata.budgetDisplayName.indexOf(' '))}`);

  console.log(`billing information: ${pubsubdata}`);
  console.log(pubsubdata);
  
  // Reformatting budget information
  const formatter = new Intl.NumberFormat('de-DE', {style: 'currency', currency: 'EUR', minimumFractionDigits: 2})
  const costAmount = formatter.format(pubsubdata.costAmount);
  const budgetAmount = formatter.format(pubsubdata.budgetAmount);
  const budgetName = pubsubdata.budgetDisplayName;
  const createdAt = new Date().toISOString();
  const project = budgetName.substr(0,budgetName.indexOf(' '))
  let threshold = (pubsubdata.alertThresholdExceeded*100).toFixed(0);
  if (!isFinite(threshold)){
   threshold = 0;
  }

  console.log(pubsubdata.costIntervalStart);
  console.log(createdAt);
  const date = new Date();
  const currentMonth = new Date(date.getFullYear(),date.getMonth(),1,00,00,00).toISOString(); 
  console.log(currentMonth); 

  // Update bugdet information in BigQuery
  console.log('insert data in bigquery');
  writeInBigQuery(pubsubdata, currentMonth, project, threshold);
  console.log('data inserted in bigquery');

  // Check if a budget thresold already exist, if not publis a message on Slack
  console.log('check if thresold exist in bigquery');
  queryBigQuery(project, costAmount, budgetAmount, threshold)
  console.log('thresold in bigquery checked');
};

// Functions needed

// eventToBuild transforms pubsub event message to a build object.
const eventToBuild = (data) => {
  return JSON.parse(Buffer.from(data, 'base64').toString());
}

// writeInBigQuery update BigQuery table
async function writeInBigQuery(pubsubdata, createdAt, project, threshold) {
  const bigquery = new BigQuery({projectId: billing_project});

  const rows = [{createdAt: createdAt,
    budgetAmount:pubsubdata.budgetAmount,
    projectName: project,
    thresholdValue: threshold}];
  console.log(rows);
  console.log('start insert row in bigquery');
  const res = await bigquery
    .dataset(dataset)
    .table(table)
    .insert(rows);
  console.log(res);
  console.log('end insert row in bigquery');
  console.log(`Inserted ${rows.length} rows`)
}

// queryBigQuery check if thresold exist in BigQuery table
async function queryBigQuery(project, costAmount, budgetAmount, threshold) {
  const bigquery = new BigQuery();

  const sqlQuery = `SELECT count(*) cnt
    FROM \`${billing_project}.${dataset}.${table}\`
    WHERE createdAt =  TIMESTAMP( DATE(EXTRACT(YEAR FROM CURRENT_DATE()) , EXTRACT(MONTH FROM CURRENT_DATE()), 1)) 
    AND thresholdValue = ${threshold}
    AND projectName = '${project}'`;

  const options = {query: sqlQuery,location: 'EU'};
  console.log(sqlQuery);
  console.log(options);

  const [job] = await bigquery.createQueryJob(options);
  console.log(`Job ${job.id} started.`);

  // Wait for the query to finish
  const [results] = await job.getQueryResults();
  console.log(`results.length: ${results.length}`);
  console.log(`results[0].cnt: ${results[0].cnt}`);
  
  if (results.length > 0 && results[0].cnt > 1 ){
    console.log('thresold already existing, doing nothing !');
    return
 }
  console.log("new thresold reached, publising a message on Slack");
  // Send message to Slack.
  const message = createSlackMessage(project, costAmount, budgetAmount, threshold);
  webhook.send(message);
}

// createSlackMessage creates a message from a build object.
const createSlackMessage = (project, costAmount, budgetAmount, threshold) => {

  // template to write message in Slack
  const emoticon = threshold >= 90 ? ':fire:' : ':white_check_mark:';
  notification = `${emoticon} Project: ${project}\nOverall cost:  ${costAmount} \nTotal Budget: ${budgetAmount}\nThresold: ${threshold}%\nThis is an automated notification to inform you that your billing account has exceeded ${threshold}% of the monthly budget of ${budgetAmount}.The billing account reached a total of ${costAmount} for the current month`

  console.log('sending a Slack message');
  const message = {
    text: notification
  };
  return message;
}