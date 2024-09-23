FROM openjdk:8-alpine3.9

MAINTAINER https://github.com/Locusc

RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories

RUN apk --update add curl bash tzdata && \
    rm -rf /var/cache/apk/* \

ENV TZ Asia/Shanghai
ARG JAR_FILE
COPY ${JAR_FILE} /opt/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/opt/app.jar"]