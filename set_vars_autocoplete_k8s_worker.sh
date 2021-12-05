##sudo sh ./install-k8s-master-ubuntu-20.04.sh

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc 
echo 'complete -F __start_kubectl k' >> ~/.bashrc

 



