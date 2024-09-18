# kubeadm初始化k8s
kubeadm init --apiserver-advertise-address=192.168.59.4 --kubernetes-version v1.17.5 \
--service-cidr=10.1.0.0/16 --pod-network-cidr=10.81.0.0/16

# 使用kubeadm将节点加入集群
kubeadm join 192.168.59.4:6443 --token z32cyo.8gmpyhuojpra90zy \
--discovery-token-ca-cert-hash sha256:b83a98530ebed89419ac081a78c6d9ca43bf52dacd827a8093c52303500eec38