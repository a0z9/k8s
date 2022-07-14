
## src: https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.0/aio/deploy/recommended.yaml

cat <<EOT > dashboard-adminuser-svc.yml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard	
EOT

cat <<EOT > dashboard-adminuser.yml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOT


kubectl apply -f dashboard-adminuser-svc.yml
kubectl apply -f dashboard-adminuser.yml

#kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

echo -- run proxy as: 'kubectl proxy --address='0.0.0.0' --disable-filter=true' --
echo -- access via k8s api: 'http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login' --
#kubectl -n kubernetes-dashboard delete serviceaccount admin-user
#kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user
