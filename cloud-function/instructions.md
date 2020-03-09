# How to deploy cloud functions:

## Publish status of gcloud build on Slack
go to the folder `cloud-function/gcloud-build-slack`:
`gcloud functions deploy subscribeSlack  --region=europe-west1 --stage-bucket gs://custom-ai-platform-notebook-cloudbuilds --trigger-topic cloud-builds --runtime nodejs10  --set-env-vars "SLACK_WEBHOOK_URL=https://hooks.slack.com/services/xxxx"`

