# НЕ РАБОТАЕТ!!
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml


#1.
#https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/


git clone https://github.com/nginxinc/kubernetes-ingress/
cd kubernetes-ingress/deployments
git checkout v2.0.3

echo --- Configure RBAC ---

kubectl apply -f common/ns-and-sa.yaml
kubectl apply -f rbac/rbac.yaml
kubectl apply -f rbac/ap-rbac.yaml

echo --- Create Common Resources ---

kubectl apply -f common/default-server-secret.yaml
kubectl apply -f common/nginx-config.yaml
kubectl apply -f common/ingress-class.yaml

echo --- Run the Ingress Controller ---

kubectl apply -f deployment/nginx-ingress.yaml
kubectl get pods --namespace=nginx-ingress

echo -- Create service with NodePort ---
#kubectl create -f service/nodeport.yaml
#не запускается

#выполняем теперь:

#https://kubernetes.github.io/ingress-nginx/deploy/

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.0/deploy/static/provider/baremetal/deploy.yaml
#ok

#ingress-nginx-controller             NodePort    10.101.103.124   <none>        80:31466/TCP,443:30793/TCP   38m
#ingress-nginx-controller-admission   ClusterIP   10.110.12.86     <none>        443/TCP                      3


#install cert manager - optional for grafana & prometheus
#https://artifacthub.io/packages/helm/cert-manager/cert-manager
#kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.crds.yaml


