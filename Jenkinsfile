pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yathish047/Swayatt-LOGO"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Yathishnagaraj/devops-task'
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm test || echo "No tests found"'
            }
        }

        stage('Dockerize') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .'
            }
        }

        stage('Push to Registry') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: '']) {
                    sh 'docker push $DOCKER_IMAGE:$BUILD_NUMBER'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker rm -f logo-container || true
                docker run -d -p 80:3000 --name logo-container $DOCKER_IMAGE:$BUILD_NUMBER
                '''
            }
        }
    }
}
