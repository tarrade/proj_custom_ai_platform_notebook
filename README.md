# Creation of Custom AI Platform Notebooks

## Introduction
The goal of this Github repository is to create and deploy custom AI Platform Notebooks on GCP.
A derived image of AI Platform Notebooks is created with a custom list of Anaconda packages,
Jupyter Lab extensions and default parameters. Hereby, a CI/CD pipeline with Cloud Build is created where a Docker image is built,
saved in Container Registry and deployed using the Deployment Manager.

## Preparations for the Environment
In this section, the connection to the right Github repository is made and GCP is set up properly for the pipeline.

[Preparations](doc/INSTRUCTION.md)

## Setup AI Platform Notebook
When the GCP environment is ready, a custom AI Platform Notebook can be set up for any project with specific needs.

[Notebook Configuration](doc/SETUP.md)

