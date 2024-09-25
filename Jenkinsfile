pipeline {

    agent any

    environment {
        HARBOR_ADDRESS = "192.168.59.3:5000/public"
        HARBOR_USERNAME = "admin"
        HARBOR_PASSWORD = "Harbor12345"
        PROJECT = "ci-cd"
        APP_NAME = "kubernetes-practice"
        DOCKERFILE_PATH = "."
        K8S_REMOTE_USER = "root"
        K8S_REMOTE_PORT = "22"
        K8S_REMOTE_IP = "192.168.59.4"
        K8S_RESOURCE_FILE = "kubernetes-practice-deployment.yml"
    }

    triggers {
        GenericTrigger(
            causeString: 'Triggered by Webhook',
            token: 'ci-cd-test01',
            printContributedVariables: true,
            printPostContent: true,
            genericHeaderVariables: [
                [key: 'User-Agent'],
                [key: 'X-Gitlab-Event']
            ],
            genericVariables: [
                [key: 'source_branch', value: '$.object_attributes.source_branch'],
                [key: 'target_branch', value: '$.object_attributes.target_branch'],
                [key: 'repository_url', value: '$.repository.git_http_url'],
                [key: 'ref', value: '$.ref']
            ]
        )
    }

    stages {
        stage('1.环境检查') {
            steps {
                echo '开始环境检查...'
                sh label: '',
                    script: '''java -version
                        mvn -v
                        git version
                        docker -v
                   '''
                echo '环境检查完成...'
            }
        }

        stage('2.拉取代码') {
            steps {
                echo '开始拉取代码...'
                script {
                    // GITLAB可能会同时触发MERGE以及PUSH事件, 有必要可以增加对最近构建记录的判断
                    // 如果最近的构建记录分支以及commit-id一致, 则不进行构建
                    echo "Webhook User-Agent -> ${env.User_Agent}"
                    echo "Webhook X-Gitlab-Event -> ${env.X_Gitlab_Event}"
                    if (!env.User_Agent || !env.User_Agent.startsWith('GitLab')) {
                        echo '非Webhook触发方式无需切换分支'
                        return
                    }
                    def event = env.X_Gitlab_Event
                    if (!event) {
                        error 'Webhook方式触发但事件类型不存在'
                    }
                    def upgrade = {String branch ->
                        sh """
                            git fetch origin
                            git checkout ${branch}
                            git pull origin ${branch}
                        """
                    }
                    if (event.equals("Merge Request Hook")) {
                        def branch = env.target_branch
                        echo "切换Webhook-Merge-Event对应分支: ${branch}"
                        upgrade(branch)
                        return
                    }
                    if (event.equals("Push Hook")) {
                        def branch = env.ref.replace('refs/heads/', '')
                        echo "切换Webhook-Push-Event对应分支: ${env.repository_url}/${branch}"
                        upgrade(branch)
                        return
                    }
                    error "未知的Webhook事件类型: ${event}, 构建中断."
                }
                echo '拉取代码完成...'
            }
        }

        stage('3.编译项目') {
            steps {
                echo '开始编译项目...'
                sh label: '',
                    script: '''
                        source /etc/profile
                        mvn clean package -Dmaven.test.skip=true
                        mkdir -p /opt/$PROJECT/$APP_NAME
                        rm -rf /opt/$PROJECT/$APP_NAME/*
                        find ./${DOCKERFILE_PATH}/target -maxdepth 1 -type f -name "*.jar" | xargs -i cp -f {} /opt/$PROJECT/$APP_NAME
                    '''
                echo '编译项目完成...'
            }
        }

        stage('4.参数替换') {
            steps {
                echo '开始参数替换...'
                sh label: '',
                    script: '''
                        cd /opt/$PROJECT/$APP_NAME
                        jar_name=$(ls | grep *.jar)
                        cd $WORKSPACE
                        image_tag=$(git rev-parse --short HEAD)
                        sed -i "s#placeholder#${jar_name}#" ${DOCKERFILE_PATH}/Dockerfile
                        sed -i "s#<IMAGE_TAG>#${image_tag}#" ${K8S_RESOURCE_FILE}
                        sed -i "s#REGISTRY_ADDRESS#${HARBOR_ADDRESS}/${PROJECT}/${APP_NAME}#" ${K8S_RESOURCE_FILE}
                    '''
                echo '参数替换完成...'
            }
        }

        stage('5.构建镜像') {
            steps {
                echo '开始构建镜像...'
                sh label: '',
                    script: '''
                        cd $WORKSPACE
                        image_tag=$(git rev-parse --short HEAD)
                        image_name=${HARBOR_ADDRESS}/${PROJECT}/${APP_NAME}:${image_tag}
                        docker build --rm -t ${image_name} ./$DOCKERFILE_PATH/
                        docker login ${HARBOR_ADDRESS} -u ${HARBOR_USERNAME} -p ${HARBOR_PASSWORD}
                        docker push ${image_name}
                    '''
                echo '构建镜像完成...'
            }
        }

        stage('6.部署到K8S集群') {
            steps {
                echo '开始部署到K8S集群...'
                sh label: '',
                    // script: '''
                    //     cd $WORKSPACE
                    //     ssh ${K8S_REMOTE_USER}@${K8S_REMOTE_IP} -p ${K8S_REMOTE_PORT} "mkdir -p /opt/yml/$PROJECT/$APP_NAME"
                    //     ssh ${K8S_REMOTE_USER}@${K8S_REMOTE_IP} -p ${K8S_REMOTE_PORT}  "rm -rf /opt/yml/$PROJECT/$APP_NAME/*"
                    //     scp -P ${K8S_REMOTE_PORT} ${K8S_RESOURCE_FILE} ${K8S_REMOTE_USER}@${K8S_REMOTE_IP}:/opt/yml/$PROJECT/$APP_NAME/
                    //     ssh ${K8S_REMOTE_USER}@${K8S_REMOTE_IP} -p ${K8S_REMOTE_PORT}  "kubectl apply -f /opt/yml/$PROJECT/$APP_NAME/${K8S_RESOURCE_FILE}"
                    // '''
                    script: '''
                        echo 'deploy to k8s'
                    '''
                echo '部署到K8S集群完成...'
            }
        }

        /*stage('6.部署到K8S集群') {
            steps {
                echo '开始部署到K8S集群...'
                script {
                    dir("$WORKSPACE") {
                        def command = """
                            ssh ${K8S_REMOTE_USER}@${K8S_REMOTE_IP} -p ${K8S_REMOTE_PORT} "mkdir -p /opt/yml/$PROJECT/$APP_NAME" && \
                            ssh ${K8S_REMOTE_USER}@${K8S_REMOTE_IP} -p ${K8S_REMOTE_PORT} "rm -rf /opt/yml/$PROJECT/$APP_NAME/*" && \
                            scp -P ${K8S_REMOTE_PORT} ${K8S_RESOURCE_FILE} ${K8S_REMOTE_USER}@${K8S_REMOTE_IP}:/opt/yml/$PROJECT/$APP_NAME/ && \
                            ssh ${K8S_REMOTE_USER}@${K8S_REMOTE_IP} -p ${K8S_REMOTE_PORT} "kubectl apply -f /opt/yml/$PROJECT/$APP_NAME/${K8S_RESOURCE_FILE}"
                        """
                        sh "nsenter -m -u -i -n -p -t 1 sh -c '${command}'"
                    }
                }
                echo '部署到K8S集群完成...'
            }
        }*/
    }

    post {
        always {
            echo '开始整理pipeline临时文件...'
            echo '整理pipeline临时文件完成...'
        }
    }
}
