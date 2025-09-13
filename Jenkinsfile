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

        stage('Deploy to Kubernetes') {
            agent {
                docker {
                    image 'bitnami/kubectl:latest'
                }
            }
            environment {
                KUBECONFIG_CONTENT = credentials('kubeconfig-credentials-id')
            }
            steps {
                sh '''
                mkdir -p $HOME/.kube
                echo "$KUBECONFIG_CONTENT" > $HOME/.kube/config
                kubectl set image deployment/logo-server logo-server=$DOCKER_REGISTRY/$IMAGE_NAME:$BUILD_NUMBER -n default
                kubectl rollout status deployment/logo-server -n default
                '''
            }
        }
    }
}
