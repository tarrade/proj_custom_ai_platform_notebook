# Instructions

## Update/check the link of Github repository and the folder name
- edit the file `'ci-cd/ci_cd_pipeline.yaml'`
- check and/or replace the Github repository to have the current one (i.e `https://github.com/tarrade/proj_custom_ai_platform_notebook`)
- check and/or replace the folder name `'proj_custom_ai_platform_notebook'`

## Create Cloud Storage buckets
- go to Storage
- create 2 buckets and they should have unique names:  
  'custom-ai-platform-notebook'  
  'custom-ai-platform-notebook-build-cache'  
  in script/bucket_gcp/auto-shutdown-scrip.sh check that the bucket name is the same as above or update it.
 - in 'custom-ai-platform-notebook' upload the full folder 'scripts' (NOT script, the one with 's' at the end!)

## Configure Cloud Build
- enable the API if Cloud Build has not yet been used
- open GCP Cloud Build -> Trigger
- click on 'Connect repository'
- select 'Github (Cloud Build App)' and click continue
- enter you Github account
- select 'Edit repository on Github' and select your repository
- click 'Create a push trigger'
- at the top of the page click '+ Create  Trigger'
- select your repository
- choose a name
- choose 'Tag' as Trigger Type
- under 'Build Configuration' choose ' Cloud Build configuration file' and write 'ci-cd/ci_cd_pipeline.yaml'
- in 'Substitutions variable variable' click '+ Add item' and add all the following variables and values:    
  _BUCKET custom-ai-platform-notebook (with the bucket name defined above)  
  _BUILD true  
  _CACHE_BUCKET custom-ai-platform-notebook-build-cache (with the bucket name defined above)  
  _DATE none  
  _DOCKERFILE derived-pytorch-cpu  
  _NAME_INSTANCE notebook  
  _NETWORK default  
  _OWNER fabien (with the respective owner)
  _TAG dev-v2.0.1 
- click 'Create trigger' 

# Update IAM
- go on IAM & Admin
- in IAM for xxx@cloudbuild.gserviceaccount.com, add a new role above "Cloud Build Service Account":  
  "Deployment Manager Editor"

## To start the pipeline
- create a tag in your Github
- or run manually from Cloud Build by clicking 'Run trigger'