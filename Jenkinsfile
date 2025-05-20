pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kunj22/ml-api"
        DOCKER_TAG = "v${env.BUILD_NUMBER}"
        KUBECONFIG = "${env.HOME}/.kube/config"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}", "app/")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                            docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                        }
                    }
                }
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    withCredentials([awsCredentials(credentialsId: 'aws-creds')]) {
                        sh '''
                        terraform init
                        terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Update Kubernetes Rollout Manifest') {
            steps {
                script {
                    // For macOS use: sed -i '' 's|image: kunj22/ml-api:.*|image: kunj22/ml-api:${DOCKER_TAG}|'
                    // For Linux: sed -i 's|image: kunj22/ml-api:.*|image: kunj22/ml-api:${DOCKER_TAG}|' k8s/rollout.yaml
                    sh """
                    sed -i '' 's|image: kunj22/ml-api:.*|image: kunj22/ml-api:${DOCKER_TAG}|' k8s/rollout.yaml
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f k8s/service.yaml
                kubectl apply -f k8s/rollout.yaml
                '''
            }
        }

        stage('Monitor Rollout') {
            steps {
                sh 'kubectl argo rollouts get rollout ml-api --watch --timeout=120s'
            }
        }
    }

    post {
        success {
            mail to: 'your-email@example.com',
                 subject: "SUCCESS: Canary Deployment #${env.BUILD_NUMBER}",
                 body: "The Canary Deployment of ML API succeeded. Image tag: ${DOCKER_TAG}"
        }
        failure {
            mail to: 'your-email@example.com',
                 subject: "FAILURE: Canary Deployment #${env.BUILD_NUMBER}",
                 body: "The Canary Deployment of ML API failed. Please check the Jenkins logs."
        }
    }
}

