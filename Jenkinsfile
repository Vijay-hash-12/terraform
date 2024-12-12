pipeline {
    agent any

    environment {
        // Securely retrieve the secret from Jenkins credentials and bind it to an environment variable
        VM_ADMIN_PASSWORD = credentials('Password')  // 'Password' is the Jenkins credentials ID
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
                // Set VM_ADMIN_PASSWORD as an environment variable and pass it securely to terraform
                withEnv(["vm_admin_password=${VM_ADMIN_PASSWORD}"]) {
                    bat 'terraform plan -var="Password=%vm_admin_password%"'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                // Set VM_ADMIN_PASSWORD as an environment variable and pass it securely to terraform
                withEnv(["vm_admin_password=${VM_ADMIN_PASSWORD}"]) {
                    bat 'terraform apply -auto-approve -var="Password=%vm_admin_password%"'
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

