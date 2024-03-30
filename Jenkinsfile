pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub'
        DOCKER_IMAGE_NAME = 'registry-app'
        DOCKER_IMAGE_TAG = "latest-${BUILD_NUMBER}" // Include build number in the tag
    }

    tools {
        maven 'Maven3'
        jdk 'Java17'
    }

    stages {
        stage('Cleaning Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from SCM') {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/chrisdylan237/register-app.git'
            }
        }
        stage('Maven Clean') {
            steps {
                sh 'mvn clean'
            }
        }
        stage('Maven Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(credentialsId: 'sonarqube', installationName: 'sonarqube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(env.DOCKER_IMAGE_NAME + ":" + env.DOCKER_IMAGE_TAG)
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', env.DOCKER_CREDENTIALS_ID) {
                        docker.image(env.DOCKER_IMAGE_NAME + ":" + env.DOCKER_IMAGE_TAG).push()
                    }
                }
            }
        }
    }
}
