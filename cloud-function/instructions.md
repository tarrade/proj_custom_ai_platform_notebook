# How to deploy cloud functions:

## Publish status of gcloud build on Slack
go to the folder `cloud-function/gcloud-build-slack`:  
`gcloud functions deploy subscribeSlack \`   
`--region=europe-west1 \`  
`--stage-bucket gs://custom-ai-platform-notebook-cloudbuilds \`      
`--trigger-topic cloud-builds  \`   
`--runtime nodejs10 \`     
`--set-env-vars "SLACK_WEBHOOK_URL=https://hooks.slack.com/services/xxxx"`  

## Publish billing budget alert on Slack  
first you need to create a dataset and a table in `BigQuery` :  
- in the billing project with `project_name` (name to be pass below as a parameter)  
- with `dataset_name` (name to be pass below as a parameter)  
- with `table_name` (name to be pass below as a parameter)  
- the location of the table need to be `EU` (or fix the code)   
- the table need to have the following schema:   
`createdAt	TIMESTAMP	REQUIRED`  
`budgetAmount	NUMERIC	REQUIRED`  	
`projectName	STRING	REQUIRED`  
`thresholdValue	NUMERIC	REQUIRED`  
then you need to check you `Pub/Sub` topic name `billingAlert`  
finally go to the folder `cloud-function/billing-alert-slack`:  
`gcloud functions deploy subscribeSlack \`     
`--region=europe-west1 \`     
`--trigger-topic billingAlerts \`   
`--runtime nodejs10 \`   
`--set-env-vars "SLACK_WEBHOOK_URL=https://hooks.slack.com/services/xxxx" \`   
`--set-env-vars "PROJECT_LIST=budget msg proj 1, budget msg proj 2" \`   
`--set-env-vars "DATASET=bigquery_dataset_name" \`   
`--set-env-vars "TABLE=bigquery_table_name" \`   
`--set-env-vars "PROJECT=project_name"`    
