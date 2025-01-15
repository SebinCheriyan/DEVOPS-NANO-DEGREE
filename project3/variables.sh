
set -x
export DB_USERNAME=myuser
export DB_PASSWORD=$(kubectl get secret --namespace default mysecret-postgres -o jsonpath="{.data.postgres-password}" | base64 -d)
export DB_HOST=127.0.0.1
export DB_PORT=5433
export DB_NAME=mydatabase
set +x