pipeline {
  agent {
    node {
      label 'master'
    }
  }
  environment {
    AWS_KEY = credentials('aws-keys')
  }
  stages {

    stage('Init') {
        steps {
            checkout scm
        }
    }

    stage('Build') {
        steps {
            sh './gradlew bootJar'
            archiveArtifacts artifacts: 'build/libs/*.jar', fingerprint: true
        }
    }

    stage('Dockerize') {
        steps {
            sh './gradlew docker'
        }
    }

    stage('Deploy') {
        steps {
            sh 'echo $AWS_KEY_USR'
            sh 'AWS_SECRET_ACCESS_KEY=$AWS_KEY_PSW AWS_ACCESS_KEY_ID=$AWS_KEY_USR ./deploy.sh'
        }
    }
  }
}



