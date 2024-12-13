pipeline {
    agent any
    environment {
        AZURE_SUBSCRIPTION_ID = credentials('subscriptionId')
        AZURE_CLIENT_ID       = credentials('clientId')
        AZURE_CLIENT_SECRET   = credentials('clientSecret')
        AZURE_TENANT_ID       = credentials('tenantId')
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
