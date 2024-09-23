pipeline {

  agent any

  environment {

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
        }
        echo '环境检查完成...'
      }
    }

    stage('2.拉取代码') {
      steps {
        echo '开始拉取代码...'
        echo '拉取代码完成...'
      }
    }

    stage('3.编译项目') {
      steps {
        echo '开始编译项目...'
        echo '编译项目完成...'
      }
    }

    stage('5.构建镜像') {
      steps {
        echo '开始构建镜像...'
        echo '编译项目完成...'
      }
    }

    stage('6.部署到K8S集群') {
      steps {
        echo '开始部署到K8S集群...'
        echo '部署到K8S集群完成...'
      }
    }
  }
}
