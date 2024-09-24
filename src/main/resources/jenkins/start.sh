# docker.sock 此映射卷主要用于执行docker镜像内的docker命令执行 共享当前docker的状态

docker run -itd --name jenkins -p 8080:8080 -p 50000:50000 -u root \
-e JAVA_OPTS=-Duser.timezone=Asia/Shanghai --restart=always \
-v /app/jenkins/data:/var/jenkins_home/ \
-v /usr/bin/docker:/usr/bin/docker \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /etc/docker/daemon.json:/etc/docker/daemon.json \
locusc/jenkins:2.401.3-lts-alpine
