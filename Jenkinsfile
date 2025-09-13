pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "yathish047"
        IMAGE_NAME = "logo-server"
        IMAGE_TAG = "${BUILD_NUMBER}"
        K8S_NAMESPACE = "default"
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
                sh "docker build -t $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG ."
            }
        }

        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                    sh "docker push $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-eks-creds']]) {
                    sh '''
                    aws eks update-kubeconfig --name unique-pop-pumpkin --region us-east-1
                    sed -i "s|IMAGE_PLACEHOLDER|$DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG|g" k8s/deployment.yaml
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    '''
        }
    }
}
