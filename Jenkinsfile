pipeline {
  agent any
  stages {
    stage('Build docker image') {
      steps {
        sh 'docker-compose build --no-cache'
      }
    }
  }
}