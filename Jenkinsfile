pipeline {
    agent any

    environment {
        // Securely retrieve the secret from Jenkins credentials and bind it to an environment variable
        VM_ADMIN_PASSWORD = credentials('Password')
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your Terraform code from the Git repository
                git 'https://github.com/Vijay-hash-12/terraform.git'
            }
        }
        
        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                script {
                    bat 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                // Set VM_ADMIN_PASSWORD as an environment variable without Groovy interpolation
                withEnv(["vm_admin_password=${VM_ADMIN_PASSWORD}"]) {
                    bat 'terraform plan -var="vm_admin_password=%vm_admin_password%"'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                // Set VM_ADMIN_PASSWORD as an environment variable without Groovy interpolation
                withEnv(["vm_admin_password=${VM_ADMIN_PASSWORD}"]) {
                    bat 'terraform apply -auto-approve -var="vm_admin_password=%vm_admin_password%"'
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
