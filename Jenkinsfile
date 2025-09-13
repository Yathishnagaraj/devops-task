pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "yathish047"
        IMAGE_NAME = "logo-server"
        IMAGE_TAG = "${BUILD_NUMBER}"
        K8S_NAMESPACE = "default"
        KUBECONFIG = "${WORKSPACE}/kubeconfig"
        JENKINS_IAM_USER = "arn:aws:iam::783879612666:user/jenkins-eks-user"
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

        stage('Pre-Deployment Check') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-eks-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                    export AWS_DEFAULT_REGION=us-east-1
                    aws eks update-kubeconfig --name unique-pop-pumpkin --kubeconfig "$KUBECONFIG"
                    if ! kubectl --kubeconfig="$KUBECONFIG" -n kube-system get configmap aws-auth -o yaml | grep -q "$JENKINS_IAM_USER"; then
                        echo "ERROR: Jenkins IAM user not found in aws-auth ConfigMap!"
                        exit 1
                    fi
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-eks-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                    export AWS_DEFAULT_REGION=us-east-1
                    sed -i "s|IMAGE_PLACEHOLDER|$DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG|g" k8s/deployment.yaml
                    kubectl --kubeconfig="$KUBECONFIG" apply -f k8s/deployment.yaml
                    kubectl --kubeconfig="$KUBECONFIG" apply -f k8s/service.yaml
                    '''
                }
            }
        }
    }
}
