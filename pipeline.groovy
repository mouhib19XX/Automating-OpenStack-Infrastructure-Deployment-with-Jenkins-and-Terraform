pipeline {
    agent any

    environment {
        TF_WORKING_DIR = '/home/jenkins/AdminTF'
    }

    stages {
        stage('Terraform Init') {
            steps {
                script {
                    dir("${TF_WORKING_DIR}") {
                        sh "terraform init -input=false"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    dir("${TF_WORKING_DIR}") {
                        sh "terraform plan -input=false"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    input message: 'Do you want to apply these Terraform changes?', ok: 'Apply'
                    dir("${TF_WORKING_DIR}") {
                        sh "terraform apply -auto-approve "
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform pipeline executed successfully!'
        }
        failure {
            echo 'Terraform pipeline failed!'
        }
    }
}
