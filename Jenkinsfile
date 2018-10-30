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
                   -Dsonar.host.url=http://a3ff3841adc6911e88b4502f479eb233-1848527067.us-east-1.elb.amazonaws.com:9000/sonar \
                     -Dsonar.login=27611792bf2429b511d65ff7e8dd153ae4165815
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



