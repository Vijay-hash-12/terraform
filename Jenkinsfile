pipeline {
    agent any

    environment {
        // Use Jenkins credentials securely
        VM_ADMIN_PASSWORD = credentials('VM_ADMIN_PASSWORD')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Vijay-hash-12/terraform.git'
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    bat 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    // Correct: Use single quotes to prevent interpolation
                    // This avoids leaking sensitive variables
                    bat "terraform plan -var='vm_admin_password=${VM_ADMIN_PASSWORD}'"
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    // Correct: Use single quotes to prevent interpolation
                    bat "terraform apply -auto-approve -var='vm_admin_password=${VM_ADMIN_PASSWORD}'"
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
        }
        success {
            echo 'Terraform execution completed successfully!'
        }
        failure {
            echo 'Terraform execution failed.'
        }
    }
}
