# Udacity-Udagram

Deploy a high-availability web app using cloudformation

## Assignment description

In this project, you’ll deploy web servers for a highly available web app using CloudFormation.
You will write the code that creates and deploys the infrastructure and application for an Instagram-like app from the ground up.
You will begin with deploying the networking components, followed by servers, security roles and software.
The procedure you follow here will become part of your portfolio of cloud projects.
You’ll do it exactly as it’s done on the job - following best practices and scripting as much as possible.

## Usage Udagram

create:

    $ ./scripts/create.sh udacity-udagram infrastructure/udagram-main.yml infrastructure/udagram-main-parameters.json
    

update:

    $ ./scripts/update.sh udacity-udagram infrastructure/udagram-main.yml infrastructure/udagram-main-parameters.json 
