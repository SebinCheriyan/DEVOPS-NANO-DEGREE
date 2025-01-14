
#Set kubectl config
aws eks --region us-east-1 update-kubeconfig --name EKS-Cluster-Udacity-Project

# Commands to setup Postgres DB
kubectl apply -f pvc.yaml
kubectl apply -f pv.yaml
kubectl apply -f postgresql-deployment.yaml

#kubectl commands to check the DB details.
kubectl get pods
kubectl exec -it postgresql-6654c4c8db-wkfx6 -- bash
# then
psql -U myuser -d mydatabase

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

# App has been build and test local python environment. Now directly mocing Docker build.
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

# Now build the image using the docker file created in analytics folder.
docker build -t test-coworking-analytics .

#Test the image created using local host to use the port forearding to connect Postgres Server
docker run --network="host" test-coworking-analytics

#Then open another terminal and run the below curl command to verify the results mentioned in the project explanation.
curl 127.0.0.1:5153/api/reports/daily_usage
curl 127.0.0.1:5153/api/reports/user_visits


# Now create the buildcode for CI/CD using the iaac_codebuild.yaml template in iaac folder.
./create.sh codebuilder-stack iaac_codebuild.yaml