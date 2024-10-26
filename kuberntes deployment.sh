#1.
kubectl get nodes -o wide
kubectl cluster-info

kubectl cluster-info | grep 'Kubernetes'

#2. Deploy mysql and webapp as pods
kubectl create namespace mysql-namespace
kubectl create namespace webapp-namespace


aws ecr get-login-password --region us-east-1
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 318623136204.dkr.ecr.us-east-1.amazonaws.com


kubectl create secret docker-registry my-ecr-secret \
    --docker-server=318623136204.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="replace with secret key" \
    --docker-email="athakur33@myseneca.ca" 

kubectl create secret docker-registry my-ecr-secret \
    --docker-server=318623136204.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="replace with secret key" \
    --docker-email="athakur33@myseneca.ca" \
    -n webapp-namespace

kubectl create secret docker-registry my-ecr-secret \
    --docker-server=318623136204.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="replace with secret key" \
    --docker-email="athakur33@myseneca.ca" \
    -n mysql-namespace


kubectl apply -f mysql-pod.yaml
kubectl apply -f mysql-service.yaml --namespace mysql-namespace

kubectl apply -f webapp-pod.yaml


kubectl get pods -o wide -n mysql-namespace
kubectl get pods -o wide -n webapp-namespace

#2b.
kubectl exec -it webapp -n webapp-namespace -- bash
apt-get update && apt-get install -y curl
curl http://localhost:8080
exit

#2c.
kubectl logs webapp

#3.
kubectl apply -f mysql-replicaset.yaml --namespace mysql-namespace
kubectl apply -f webapp-replicaset.yaml --namespace webapp-namespace

kubectl get rs -o wide -n mysql-namespace
kubectl get rs -o wide -n webapp-namespace
 kubectl get pods --show-labels -n mysql-namespace
 kubectl get pods --show-labels -n webapp-namespace
#It starts including the earlier created pod too

#4.
kubectl apply -f mysql-deployment.yaml --namespace mysql-namespace
kubectl apply -f webapp-deployment.yaml --namespace webapp-namespace
kubectl get deployment -o wide -n mysql-namespace
kubectl get rs -o wide -n mysql-namespace

kubectl get deployment -o wide -n webapp-namespace
kubectl get rs -o wide -n webapp-namespace

#5.
kubectl apply -f webapp-service.yaml --namespace webapp-namespace

#6. 
#Execute Github Actions and update image uri
vim webapp-deployment.yaml 
kubectl apply -f webapp-deployment.yaml -n webapp-namespace
kubectl rollout status deployment/webapp-deployment -n webapp-namespace

# Cleanup all deployments

# Delete all deployments
kubectl delete deployments --all
# Delete all replica sets
kubectl delete replicasets --all
# Delete all pods
kubectl delete pods --all
# Delete all services
kubectl delete services --all
# Delete all namespaces
kubectl delete namespace --all