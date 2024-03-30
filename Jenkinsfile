pipeline {
    agent any

    environment {
        APP_NAME = "register-app"
        DOCKER_USER = "chrisdylan"
        DOCKER_CREDENTIALS_ID = 'dockerhub'
        DOCKER_IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
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
                    docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}").push()
                    }
                }
            }
        }
        stage('Trivy Scan') {
            steps {
                script {
                    sh "docker pull aquasec/trivy"
                    sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy -s HIGH,CRITICAL ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                }
            }
        }
    }
}
