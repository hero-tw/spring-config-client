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

    stage('Test') {
       steps {
           script {
              try {
                sh 'AWS_SECRET_ACCESS_KEY=$AWS_KEY_PSW AWS_ACCESS_KEY_ID=$AWS_KEY_USR ./gradlew check'
              } finally {
                publishHTML(target: [reportDir:'build/reports/tests/test',
                                                    reportFiles: 'index.html',
                                                    reportName: 'Unit Tests', keepAll: true])
                publishHTML(target: [reportDir:'build/reports/findbugs',
                                    reportFiles: 'main.html,test.html,contractTest.html',
                                    reportName: 'FindBugs', keepAll: true])
                publishHTML(target: [reportDir:'build/reports/jacoco/test/html',
                    reportFiles: 'index.html',
                    reportName: 'Code Coverage', keepAll: true])

            }
         }
     }
    }

    stage('Dockerize') {
        steps {
            sh './gradlew docker'
        }
    }

    stage('Deploy') {
        steps {
            sh 'AWS_SECRET_ACCESS_KEY=$AWS_KEY_PSW AWS_ACCESS_KEY_ID=$AWS_KEY_USR ./deploy.sh'
        }
    }
  }
}



