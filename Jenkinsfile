pipeline {
    agent any
    environment {
        ARM_CLIENT_ID = credentials('clientId')  // Retrieved from Jenkins Credentials store
        ARM_CLIENT_SECRET = credentials('clientSecret')  // Retrieved from Jenkins Credentials store
        ARM_SUBSCRIPTION_ID = credentials('subscriptionId')  // Corrected to use 'subscriptionId' credential
        ARM_TENANT_ID = credentials('tenantId')  // Retrieved from Jenkins Credentials store
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
                    bat 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                withCredentials([string(credentialsId: 'Password', variable: 'VM_ADMIN_PASSWORD')]) {
                    bat 'terraform plan -var="Password=%VM_ADMIN_PASSWORD%"'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
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
