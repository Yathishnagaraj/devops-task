pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yathish047/swayatt-logo"
        CONTAINER_NAME = "logo-container"
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
                // Run tests if they exist
                sh 'npm test || echo "No tests found"'
            }
        }

        stage('Dockerize') {
            steps {
                sh '''
                docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .
                docker tag $DOCKER_IMAGE:$BUILD_NUMBER $DOCKER_IMAGE:latest
                '''
            }
        }

        stage('Push to Registry') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: '']) {
                    sh '''
                    docker push $DOCKER_IMAGE:$BUILD_NUMBER
                    docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker rm -f $CONTAINER_NAME || true
                docker run -d -p 80:3000 --name $CONTAINER_NAME $DOCKER_IMAGE:$BUILD_NUMBER
                '''
            }
        }
    }
}
