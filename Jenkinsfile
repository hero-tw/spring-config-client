node {
    checkout scm

     environment {
        AWS_KEY = credentials('aws-keys')
    }

    stage('Test') {
       script {
          try {
            sh './gradlew check'
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

    stage('Build') {
        sh './gradlew bootJar'
        archiveArtifacts artifacts: 'build/libs/*.jar', fingerprint: true
    }

    stage('Dockerize') {
        sh './gradlew docker'
    }

    stage('Deploy') {
     withCredentials([usernamePassword(credentialsId: 'aws-keys', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
        sh 'chmod +x ./deploy.sh'
        sh './deploy.sh'
      }
    }
}


