#Build EKS cluster and ECR with associated roles using the iaac_eks_ecr.yaml template.
./create.sh eks-ecr-cluster iaac_eks_ecr.yaml

#Set kubectl config
aws eks --region us-east-1 update-kubeconfig --name EKS-Cluster-Udacity-Project

# Commands to setup Postgres DB
kubectl apply -f pvc.yaml
kubectl apply -f pv.yaml
kubectl apply -f postgresql-deployment.yaml

#kubectl commands to check the DB details.
kubectl get pods
kubectl exec -it postgresql-6654c4c8db-jjk62 -- bash
# then
psql -U myuser -d mydatabase
\l
\dt

# To port forward - create a service.
kubectl apply -f postgresql-service.yaml

#Then do port forwarding as follows.
kubectl get svc
kubectl port-forward --namespace default svc/postgresql-service 5433:5432 &
# To check the port forwarding - 
netstat -an | grep 5433


# Data Instert into the DB. So install psql local as follows.
sudo apt update
sudo apt install postgresql postgresql-contrib

# Then run the db/db_data_insert.sh file as follows.
./db_data_insert.sh

# Then check the table by connection to Postgres Server as follows.
PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U myuser -d mydatabase -p 5433
select * from users limit 10;
select * from tokens limit 10;

# App has been build and test local python environment. Now directly mocing Docker build.
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

# Now build the image using the docker file created in analytics folder. Go to analytics folder and run the command below.
docker build -t test-coworking-analytics .

#Test the image created using local host to use the port forearding to connect Postgres Server
docker run --network="host" test-coworking-analytics

#Then open another terminal and run the below curl command to verify the results mentioned in the project explanation.
curl 127.0.0.1:5153/api/reports/daily_usage
curl 127.0.0.1:5153/api/reports/user_visits


# Now create the buildcode for CI/CD using the iaac_codebuild.yaml template in iaac folder.
./create.sh codebuilder-stack iaac_codebuild.yaml
# Once it done then run the codebuild project created to create the image from the dockerfile in GIthub and push that to the coworking ECR repository. Check the version whether it updated with CODE_BUILD_NUMBER.

# Now the image has created and pushed to the ECR repo. Let's deploy the app.
# Update the given configmap.yaml with secret details, DB details and user details. Then execute it.
kubectl apply -f configmap.yaml

#Run the below command to get the DB_PASSWORD as expected.
kubectl get secret mysecret-postgres -o jsonpath="{.data.postgres-password}" | base64 -d

#Update the details from configmap.yaml in coworking.yaml (Secrets and IMahe URI) and create the Service and Deployment.
kubectl apply -f coworking.yaml

#Now run the below CURL command to verify the deployment.
#first run the below command and get the external IP and port for the coworking Service.
kubectl get svc

#Use that value in the below curl command and execute.
curl a99bbd2aef9f14cd789db3943aa14a40-1345046499.us-east-1.elb.amazonaws.com:5153/api/reports/daily_usage
curl a99bbd2aef9f14cd789db3943aa14a40-1345046499.us-east-1.elb.amazonaws.com:5153/api/reports/user_visits