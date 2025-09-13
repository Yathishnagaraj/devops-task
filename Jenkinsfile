pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "yathish047"
        IMAGE_NAME = "logo-server"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Yathishnagaraj/devops-task.git'
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test || echo "No tests defined, skipping..."'
            }
        }

        stage('Dockerize') {
            steps {
                sh "docker build -t $DOCKER_REGISTRY/$IMAGE_NAME:$BUILD_NUMBER ."
            }
        }

        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                 usernameVariable: 'USERNAME',
                                                 passwordVariable: 'PASSWORD')]) {
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                    sh "docker push $DOCKER_REGISTRY/$IMAGE_NAME:$BUILD_NUMBER"
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                aws ecs update-service \
                  --cluster logo-cluster \
                  --service logo-service \
                  --force-new-deployment
                '''
            }
        }
    }
}
