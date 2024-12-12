pipeline {
    agent any

    environment {
        // Binding the 'vm_admin_password' to the 'xyz' secret text credential
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
                // Run 'terraform plan' and securely pass the password as a variable
                script {
                    bat "terraform plan -var='vm_admin_password=${VM_ADMIN_PASSWORD}'"
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                // Run 'terraform apply' and securely pass the password as a variable
                script {
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
