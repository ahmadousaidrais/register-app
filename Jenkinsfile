pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'Java17'
        sonarqubeScanner 'sonnarqube-scans'
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
                withSonarQubeEnv(credentialsId: 'sonarqube-token', installationName: 'sonnarqube-scans') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
    }
}
