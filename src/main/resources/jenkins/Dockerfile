# https://updates.jenkins.io/current/update-center.json

FROM 192.168.59.3:5000/public/jenkins/jenkins:2.401.3-lts-centos7

MAINTAINER https://github.com/Locusc

# 镜像默认用户无法执行以下操作 - jenkins用户
USER root

#RUN echo -e 'https://mirrors.aliyun.com/alpine/v3.6/main/\nhttps://mirrors.aliyun.com/alpine/v3.6/community/' > /etc/apk/repositories \
#    && apk update \
#    && apk upgrade
#
#RUN apk --update --no-cache add curl bash tzdata && \
#    rm -rf /var/cache/apk/*

#COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
#
#RUN yum -y install curl bash tzdata && \
#    yum clean all && \
#    yum makecache

ENV TZ Asia/Shanghai
ENV JENKINS_UC https://updates.jenkins-zh.cn
ENV JENKINS_UC_DOWNLOAD https://mirrors.tuna.tsinghua.edu.cn/jenkins
ENV JENKINS_OPTS="Dhudson.model.UpdateCenter.updateCenterUrl=https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/dynamic-stable-2.401.3/update-center.json"
ENV JENKINS_OPTS="-Djenkins.install.runSetupWizard=false"
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/init.groovy
COPY hudson.model.UpdateCenter.xml /usr/share/jenkins/ref/hudson.model.UpdateCenter.xml
COPY mirror-adapter.crt /usr/share/jenkins/ref/mirror-adapter.crt

ENV MAVEN_VERSION 3.6.3
ENV MAVEN_HOME /opt/maven
ENV MAVEN_URL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz

COPY apache-maven-3.6.3-bin.tar.gz /tmp/maven.tar.gz

RUN mkdir -p /opt \
    # && curl -fsSL ${MAVEN_URL} -o /tmp/maven.tar.gz \
    && tar -xzf /tmp/maven.tar.gz -C /opt \
    && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven \
    && rm /tmp/maven.tar.gz

# 设置 Maven 环境变量
ENV PATH=${MAVEN_HOME}/bin:${PATH}
