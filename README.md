# kubeadm初始化k8s
kubeadm init --apiserver-advertise-address=192.168.59.4 --kubernetes-version v1.17.5 \
--service-cidr=10.1.0.0/16 --pod-network-cidr=10.81.0.0/16

# 使用kubeadm将节点加入集群
kubeadm join 192.168.59.4:6443 --token z32cyo.8gmpyhuojpra90zy \
--discovery-token-ca-cert-hash sha256:b83a98530ebed89419ac081a78c6d9ca43bf52dacd827a8093c52303500eec38

# 常用命令
kubectl scale replicaset replicasetdemo --replicas=5
kubectl edit replicasets.apps replicasetdemo (通过修改资源配置清单的方式可以进行扩容缩容镜像升级等...)
kubectl get pod -o wide
kubectl get pod --show-labels
kubectl get label pod replicasetdemo-xxx app=replicasetdemo-ow --overwrite=True
kubectl describe 'type' 'name'
kubectl exec -it 'name' /bin/bash or sh (同docker)
kubectl logs -f 'name' (同docker)
kubectl logs 'name' -c 'container name' (查询关联容器日志)
kubectl set image deployment deploymentdemo deploymentdemo=nginx:1.18.0-alpine (资源名称|pod标签名称)
kubectl explain '节点' (资源yaml配置说明)

推荐使用资源配置清单
kubectl run tomcat-test --image=tomcat:9.0.20-jre8-alpine --port=8080 (直接运行一个pod, 不会创建控制器, 已废弃)
kubectl expose deployment tomcat-test --name=tomcat9-svc --port=8888 --target-port=8080 --protocol=TCP --type=NodePort (控制器创建pod不建议使用)

# 灰度发布示例(k8s对集群资源做部分更新后暂停, 调试完成后使用resume继续更新)
kubectl set image deployment deploymentdemo deploymentdemo=nginx:1.18.0-alpine && kubectl rollout pause deployment deploymentdemo
kubectl rollout status deployments deploymentdemo
kubectl rollout resume deploy deploymentdemo

kubectl rollout history deployment deploymentdemo --revision=1 (查询历史版本)
kubectl rollout undo deployment deploymentdemo -to-revision=1 (版本回滚)

# 集群注册私服
kubectl create secret docker-registry harbor-59.3 \
--docker-server=192.168.59.3:5000 --docker-username=admin \
--docker-password=Harbor12345 --docker-email=locusc@163.cn

# configmap
kubectl create configmap mysql-ini --from-file=my.cnf (指定文件名方式生产配置)
kubectl get configmap mysql-ini -o yaml > mariadb-configmap.yml (反向生产k8s-yaml)

# labels操作
kubectl label nodes <node-name> <label-key>=<label-value>
kubectl label nodes <node-name> <label-key>=<label-value> --overwrite
kubectl label nodes <node-name> <label-key>-
kubectl get nodes --show-labels

# 资源亲和度(与污点相反)
spec.affinity.nodeAffinity
spec.affinity.podAffinity

# 调度污点-节点 -> 调度容忍度(对污点的容忍度)-pod
kubectl taint nodes node1 key1=value1:NoSchedule
kubectl taint nodes node1 key1:NoSchedule-