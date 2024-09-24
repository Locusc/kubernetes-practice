# kubeadm初始化k8s
1. kubeadm init --apiserver-advertise-address=192.168.59.4 --kubernetes-version v1.17.5 \
--service-cidr=10.1.0.0/16 --pod-network-cidr=10.81.0.0/16

# 使用kubeadm将节点加入集群
1. kubeadm join 192.168.59.4:6443 --token z32cyo.8gmpyhuojpra90zy \
--discovery-token-ca-cert-hash sha256:b83a98530ebed89419ac081a78c6d9ca43bf52dacd827a8093c52303500eec38

# 常用命令
1. kubectl scale replicaset replicasetdemo --replicas=5
2. kubectl edit replicasets.apps replicasetdemo (通过修改资源配置清单的方式可以进行扩容缩容镜像升级等...)
3. kubectl get pod -o wide
4. kubectl get pod --show-labels
5. kubectl get label pod replicasetdemo-xxx app=replicasetdemo-ow --overwrite=True
6. kubectl describe 'type' 'name'
7. kubectl exec -it 'name' /bin/bash or sh (同docker)
8. kubectl logs -f 'name' (同docker)
9. kubectl logs 'name' -c 'container name' (查询关联容器日志)
10. kubectl set image deployment deploymentdemo deploymentdemo=nginx:1.18.0-alpine (资源名称|pod标签名称)
11. kubectl explain '节点' (资源yaml配置说明)

推荐使用资源配置清单
1. kubectl run tomcat-test --image=tomcat:9.0.20-jre8-alpine --port=8080 (直接运行一个pod, 不会创建控制器, 已废弃)
2. kubectl expose deployment tomcat-test --name=tomcat9-svc --port=8888 --target-port=8080 --protocol=TCP --type=NodePort (控制器创建pod不建议使用)

# 灰度发布示例(k8s对集群资源做部分更新后暂停, 调试完成后使用resume继续更新)
1. kubectl set image deployment deploymentdemo deploymentdemo=nginx:1.18.0-alpine && kubectl rollout pause deployment deploymentdemo
2. kubectl rollout status deployments deploymentdemo
3. kubectl rollout resume deploy deploymentdemo

4. kubectl rollout history deployment deploymentdemo --revision=1 (查询历史版本)
5. kubectl rollout undo deployment deploymentdemo -to-revision=1 (版本回滚)

# 集群注册私服
1. kubectl create secret docker-registry harbor-59.3 \
--docker-server=192.168.59.3:5000 --docker-username=admin \
--docker-password=Harbor12345 --docker-email=locusc@163.cn

# configmap
1. kubectl create configmap mysql-ini --from-file=my.cnf (指定文件名方式生产配置)
2. kubectl get configmap mysql-ini -o yaml > mariadb-configmap.yml (反向生产k8s-yaml)

# labels操作
1. kubectl label nodes <node-name> <label-key>=<label-value>
2. kubectl label nodes <node-name> <label-key>=<label-value> --overwrite
3. kubectl label nodes <node-name> <label-key>-
4. kubectl get nodes --show-labels

# 资源亲和度(与污点相反)
1. spec.affinity.nodeAffinity
2. spec.affinity.podAffinity

# 调度污点-节点 -> 调度容忍度(对污点的容忍度)-pod
1. kubectl taint nodes node1 key1=value1:NoSchedule
2. kubectl taint nodes node1 key1:NoSchedule-