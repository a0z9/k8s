echo installing k8s worker node...

ufw disable &&  swapoff -a && sed -i 's/^\/swap/#\/swap/' /etc/fstab

cat <<EOT >> /etc/modules-load.d/k8s.conf
br_netfilter
overlay
EOT

modprobe br_netfilter && modprobe overlay

iptables -I INPUT 1 -p tcp --match multiport --dports 10240:10250,30000:32767 -j ACCEPT

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
apt-get -y install iptables-persistent

netfilter-persistent save

cat <<EOT >> /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOT

cat <<EOT >> /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOT

sysctl --system

apt-get update && apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
#apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

apt-get update && apt-get install -y kubelet kubeadm kubectl

service docker restart

tput setaf 2 && echo "start to pulling images.." && tput setaf 7
kubeadm config images pull

tput setaf 2 && echo "add worker node tu kube..." && tput setaf 7

$(echo $1)

tput setaf 2 && echo "start set up vars, alias and kubectl autocompleteion rules.." && tput setaf 7

export KUBECONFIG=/etc/kubernetes/admin.conf

apt-get install -y bash-completion

source /usr/share/bash-completion/bash_completion

cat <<EOT >> /etc/modules-load.d/k8s.conf
source /usr/share/bash-completion/bash_completion
EOT

echo 'source <(kubectl completion bash)' >> /etc/bash.bashrc
echo 'alias k=kubectl' >> /etc/bash.bashrc
echo 'complete -F __start_kubectl k' >> /etc/bash.bashrc

#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml




