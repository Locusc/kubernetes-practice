docker run -itd --name jenkins -p 8080:8080 -p 50000:50000 -u root \
-e JAVA_OPTS=-Duser.timezone=Asia/Shanghai --restart=always \
-v /data/jenkins/:/var/jenkins_home/ \
192.168.59.3:5000/public/jenkins/jenkins:2.401.3-lts-alpine
