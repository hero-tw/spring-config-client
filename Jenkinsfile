pipeline {
  agent {
    label 'autoscale'
  }
  environment {
    AWS_KEY = credentials('aws-keys')
  }
  stages {

    stage('Init') {
        steps {
            checkout scm
            sh './gradlew clean'
        }
    }

    stage('Static Scan') {
        steps {
            sh 'AWS_SECRET_ACCESS_KEY=$AWS_KEY_PSW AWS_ACCESS_KEY_ID=$AWS_KEY_USR ./gradlew sonarqube \
                   -Dsonar.host.url=http://a951ccd4ed92e11e88b4502f479eb233-829537117.us-east-1.elb.amazonaws.com:9000/sonar/ \
                   -Dsonar.login=32f52658a81e8c064e49a322f3c3604092276e9f'
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
/*    stage('Performance') {
           steps {
               script {
                  try {
                    sh 'AWS_SECRET_ACCESS_KEY=$AWS_KEY_PSW AWS_ACCESS_KEY_ID=$AWS_KEY_USR ./gradlew jmClean jmRun xslt --stacktrace'
                  } finally {
                    def htmlFiles
                    dir('build/reports/jmeter') {
                       htmlFiles = findFiles glob: '*.html'
                    }
                    publishHTML(target: [reportDir:'build/reports/jmeter',
                        reportFiles: htmlFiles.join(','),
                        reportName: 'Performance Report', keepAll: true])

                }
             }
         }
        }*/
  }
}



