pipeline {
  agent any
  stages {
    stage('Build docker image') {
      steps {
        sh 'docker-compose build --no-cache'
      }
    }
    stage('Start server') {
      steps {
        sh 'docker-compose up'
      }
    }
    stage('Stop the server') {
      steps {
        sh 'docker-compose down'
      }
    }
  }
}