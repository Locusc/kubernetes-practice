docker run -itd --name gitlab -p 443:443 -p 80:80 -p 222:22 --restart always -m 3GB -v /app/gitlab/config:/etc/gitlab \
-v /app/gitlab/logs:/var/log/gitlab -v /app/gitlab/data:/var/opt/gitlab \
-e TZ=Asia/Shanghai  192.168.59.3:5000/public/gitlab/gitlab-ee:11.0.4-ee.0

docker run -itd --name gitlab -p 443:443 -p 80:80 -p 222:22 --restart always -m 3GB \
-v /app/gitlab-ce-11.0.4/config:/etc/gitlab \
-v /app/gitlab-ce-11.0.4/logs:/var/log/gitlab \
-v /app/gitlab-ce-11.0.4/data:/var/opt/gitlab \
-e TZ=Asia/Shanghai 192.168.59.3:5000/public/gitlab/gitlab-ce:11.0.4-ce.0

docker run -itd --name gitlab -p 443:443 -p 80:80 -p 222:22 --restart always -m 3GB \
-v /app/gitlab-ce-13.8.8/config:/etc/gitlab \
-v /app/gitlab-ce-13.8.8/logs:/var/log/gitlab \
-v /app/gitlab-ce-13.8.8/data:/var/opt/gitlab \
-e TZ=Asia/Shanghai 192.168.59.3:5000/public/gitlab/gitlab-ce:13.8.8-ce.0