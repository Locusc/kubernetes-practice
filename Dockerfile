FROM 192.168.59.3:5000/public/openjdk:8-alpine3.9

MAINTAINER https://github.com/Locusc

RUN echo -e 'https://mirrors.aliyun.com/alpine/v3.6/main/\nhttps://mirrors.aliyun.com/alpine/v3.6/community/' > /etc/apk/repositories \
    && apk update \
    && apk upgrade

RUN apk --update add curl bash tzdata && \
    rm -rf /var/cache/apk/* \

ENV TZ Asia/Shanghai
ARG APP_JAR_FILE=./target/placeholder
COPY ${APP_JAR_FILE} /opt/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/opt/app.jar"]