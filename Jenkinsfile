node {
    checkout scm

    stage('Build') {
        sh './gradlew assemble'
        archiveArtifacts artifacts: 'build/libs/*.jar', fingerprint: true
    }

    stage('Dockerize') {
        sh './gradlew docker'
    }

    stage('Deploy') {
        sh './deploy.sh'
    }
}


