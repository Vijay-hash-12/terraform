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
                // Use 'withCredentials' to securely pass the password without interpolation
                withCredentials([string(credentialsId: 'Password', variable: 'VM_ADMIN_PASSWORD')]) {
                    bat 'terraform plan -var="Password=%VM_ADMIN_PASSWORD%"'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                // Use 'withCredentials' to securely pass the password without interpolation
                withCredentials([string(credentialsId: 'Password', variable: 'VM_ADMIN_PASSWORD')]) {
                    bat 'terraform apply -auto-approve -var="Password=%VM_ADMIN_PASSWORD%"'
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
