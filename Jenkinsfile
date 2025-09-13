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
                echo "Skipping Docker push for public image"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                mkdir -p $HOME/.kube
                kubectl get deployment logo-server -n ${K8S_NAMESPACE} || \
                kubectl create deployment logo-server --image=${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} -n ${K8S_NAMESPACE}
                kubectl set image deployment/logo-server logo-server=${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} -n ${K8S_NAMESPACE}
                kubectl rollout status deployment/logo-server -n ${K8S_NAMESPACE}
                '''
            }
        }
    }
}
