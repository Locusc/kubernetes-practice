# 拉取并重命名calico镜像
# !/bin/bash
images=(
    calico/cni:v3.14.2
    calico/pod2daemon-flexvol:v3.14.2
    calico/node:v3.14.2
    calico/kube-controllers:v3.14.2
 )
for imageName in ${images[@]} ;
do
    docker pull docker.m.daocloud.io/$imageName
    docker tag docker.m.daocloud.io/$imageName calico/$imageName
    docker rmi docker.m.daocloud.io/$imageName
done