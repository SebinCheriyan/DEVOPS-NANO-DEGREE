
# To port forward - 
    kubectl port-forward --namespace default svc/postgresql-service 5433:5432 &
# To check the port forwarding - 
    netstat -an | grep 5433