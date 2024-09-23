# 拉取并重命名k8s基础镜像
# !/bin/bash
# 下面的镜像应该去除"k8s.gcr.io"的前缀，版本换成kubeadm config images list命令获取到的版本
images=(
    kube-apiserver:v1.17.5
    kube-controller-manager:v1.17.5
    kube-scheduler:v1.17.5
    kube-proxy:v1.17.5
    pause:3.1
    etcd:3.4.3-0
    coredns:1.6.5
 )
for imageName in ${images[@]} ; 
do
    docker pull docker.m.daocloud.io/$imageName
    docker tag docker.m.daocloud.io/$imageName k8s.gcr.io/$imageName
    docker rmi docker.m.daocloud.io/$imageName
done
