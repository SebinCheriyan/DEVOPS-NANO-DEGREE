# Project Deployment Documentation

This is the guide to understand the deployement process for this project. It explains the set of tools used and process to deploy the pipeline along with the instructions to deploy new changes.

Use the Github project repository for this work. Clone the repo to your local IDE like VS Code. Here the codebuild pipeline integrated with Github project repo and has a webhood to identify every PUSh to the main branch and rebuild the image with the docker file and push that to ECR coworking repository.

The Application will use the image from the above ECR coworking repositoty to deploy the app in the EKS cluster.

To deploy the services, depolyments, configmaps etc to the kubernetes cluster, setup the kubectl tool. this CLI will help interdat with the API and do deploy activities.

### 2 steps of developments/upgrade.

1. Code changes in Application Image.

If there achanges or new feature addition, make the changes in the local clone repositoy of GitHub project repository. Locally build and test the image using docker local setup. Then push the code to Github. This action will trigger the codebuild project rebuild the image and push that ECR coworking repo. 

2. Now the coworking.yaml file has to apply with new changes via kubectl CLI. Always remember to update the latest image URI from ECR in yaml and update the services or deployements.

#### Updates on AWS resources
All AWS resources have been created using cloudformation template. This can be find in the iaac folder in the main project repository. Made necessary changes and update the associated stack to reflect changes in resources.

Please find a detailed step by step process for this project in DEVOPS-NANO-DEGREE/project3/utilities/project_commands.sh file with explanation.

