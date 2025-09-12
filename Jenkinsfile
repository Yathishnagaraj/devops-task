pipeline {
    agent any

    tools {
        maven "M3"
    }

    stages {
        stage('Build') {
            steps {
                git branch: 'main', url: 'https://github.com/Yathishnagaraj/devops-task.git'

                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }

            post {
                success {
                    junit '**/target/surefire-reports/TEST-*.xml'
                    archiveArtifacts 'target/*.jar'
                }
            }
        }

        stage('Dockerize') {
            steps {
                sh 'docker build -t yathish047/devops-task:latest .'
            }
        }

        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                      echo $PASS | docker login -u $USER --password-stdin
                      docker push yathish047/devops-task:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'kubectl apply -f k8s/' 
            }
        }
    }
}
