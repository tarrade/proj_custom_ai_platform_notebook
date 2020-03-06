# Instructions for the Initial Setup
The following instructions need to be followed in order to create custom environments for AI Platform Notebooks. They 
describe how custom images can be built using a docker container in GCP.

## Update/check the link of Github repository and the folder name
This Github repository is the basis to build the docker container and stays the same for every new project. Each project 
can be started by building the AI Platform Notebook that is set up using this repo which means that it is essential to 
check whether this repo is correctly linked. 

- Clone the Github repository `https://github.com/tarrade/proj_custom_ai_platform_notebook`. 
- Edit the file `'ci-cd/ci_cd_pipeline.yaml'` to suit your docker needs.
- Check and/or replace the Github repository with your current one, so you can apply custom changes (i.e. `https://github.com/tarrade/proj_custom_ai_platform_notebook`).
- Check and/or replace the folder name `'proj_custom_ai_platform_notebook'`.

## Create Cloud Storage buckets
Certain files like gitconfig, conda- or pip-specific configurations which are important for including the correct packages etc. are 
referenced during the building process. This is why these are saved separately in Google Storage which requires this setup.

- Go to Storage.
- Create 2 buckets, one for the config files and one for caching. Note: they should have globally unique names on GCP, otherwise it will not work. 

    For example:    
    `'custom-ai-platform-notebook'`     
    `'custom-ai-platform-notebook-build-cache'`  
    
 - In the file `'script/bucket_gcp/auto-shutdown-scrip.sh'`, check that the bucket name is the same as you specified it.
 - In `'custom-ai-platform-notebook'`, upload the full folder `'scripts'` (NOT script, the one with 's' at the end!).

## Configure Cloud Build
The process to set up the AI Platform Notebook using a docker container is managed in Cloud Build. 

Pushing new changes to the Github repository `'custom-ai-platform-notebook'` while 
simultaneously creating a new 
tag triggers this whole process. Each time the process is triggered (and the `_BUILD` variable specified below is set to 
`true`), a new image is built using a docker container with the updated configurations specified in the Github repo. When 
Cloud Build is done, this image gets sent to Container Registry. This ensures that the image does not have to be built 
each time a new instance of the notebook is created but instead can be loaded from the registry without the hassle of 
building the whole thing again. 

Note: Cloud Build can also be triggered manually in GCP, see section 'How to start the pipeline'.


- Enable the API if Cloud Build has not yet been used.
- Open GCP Cloud Build -> Trigger.
- Click on `Connect repository`.
- Select `Github (Cloud Build App)` and click continue.
- Enter you Github account.
- Select `Edit repository on Github` and select your repository.
- Click `Create a push trigger`.
- At the top of the page, click `+ Create Trigger`.
- Select your repository.
- Choose a name.
- Choose `Tag` as Trigger Type.
- Under `Build Configuration` choose `Cloud Build configuration file'` and write `'ci-cd/ci_cd_pipeline.yaml'`.
- In `Substitutions variable variable`, click `+ Add item` and add all the following variables and values:    
  `_BUCKET` custom-ai-platform-notebook (with the bucket name defined above)  
  `_BUILD` true  
  `_CACHE_BUCKET` custom-ai-platform-notebook-build-cache (with the bucket name defined above)  
  `_DATE` none  
  `_DOCKERFILE` derived-pytorch-cpu  
  `_NAME_INSTANCE` notebook  
  `_NETWORK` default  
  `_OWNER` fabien (with the respective owner)  
  `_TAG` dev-v2.0.1 
- Click `Create trigger`. 

## Update IAM
Here, the service account is given the appropriate permissions in order for Cloud Build to work properly.

- Go to IAM & Admin.
- In IAM for xxx@cloudbuild.gserviceaccount.com, add a new role above `Cloud Build Service Account`:  
  `Deployment Manager Editor`

## How to start the pipeline
To start the pipeline and essentially build an image from the docker container, use one of the methods below.
- Create a tag in your Github
- or run manually from Cloud Build by clicking `Run trigger`.