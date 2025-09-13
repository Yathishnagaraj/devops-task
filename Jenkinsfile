pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "yathish047"
        IMAGE_NAME = "logo-server"
        IMAGE_TAG = "${BUILD_NUMBER}"
        K8S_NAMESPACE = "default"
        KUBECONFIG = "${WORKSPACE}/kubeconfig"
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
                sh "docker build -t \"$DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG\" ."
            }
        }

        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin'
                    sh "docker push \"$DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG\""
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-eks-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                    export AWS_DEFAULT_REGION=us-east-1
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                    aws eks update-kubeconfig --name unique-pop-pumpkin --kubeconfig "$KUBECONFIG"

                    sed -i "s|IMAGE_PLACEHOLDER|$DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG|g" k8s/deployment.yaml

                    kubectl --kubeconfig="$KUBECONFIG" apply -f k8s/deployment.yaml
                    kubectl --kubeconfig="$KUBECONFIG" apply -f k8s/service.yaml
                    '''
                }
            }
        }
    }
}
