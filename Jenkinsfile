pipeline {
    agent any

    environment {
        // Optional: Define any other environment variables you may need
        TF_VAR_subscription_id = ''  // This will be replaced by Jenkins credentials
        TF_VAR_client_id = ''        // This will be replaced by Jenkins credentials
        TF_VAR_client_secret = ''    // This will be replaced by Jenkins credentials
        TF_VAR_tenant_id = ''        // This will be replaced by Jenkins credentials
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the GitHub repository
                git url: 'https://github.com/Vijay-hash-12/terraform.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Use Jenkins credentials to authenticate with Azure
                    withCredentials([
                        string(credentialsId: 'clientId', variable: 'AZURE_CLIENT_ID'),       // clientId renamed
                        string(credentialsId: 'clientSecret', variable: 'AZURE_CLIENT_SECRET'),  // clientSecret renamed
                        string(credentialsId: 'subscriptionId', variable: 'AZURE_SUBSCRIPTION_ID'),  // subscriptionId renamed
                        string(credentialsId: 'tenantId', variable: 'AZURE_TENANT_ID')         // tenantId renamed
                    ]) {
                        // Set environment variables for Terraform authentication
                        bat '''
                            set ARM_CLIENT_ID=%AZURE_CLIENT_ID%
                            set ARM_CLIENT_SECRET=%AZURE_CLIENT_SECRET%
                            set ARM_SUBSCRIPTION_ID=%AZURE_SUBSCRIPTION_ID%
                            set ARM_TENANT_ID=%AZURE_TENANT_ID%
                            terraform init
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Run Terraform plan to see what changes will be applied
                    bat 'terraform plan -var="Password"'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the changes using Terraform with auto-approval
                    bat 'terraform apply -var="Password=$VM_ADMIN_PASSWORD" -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform pipeline executed successfully.'
        }
        failure {
            echo 'Terraform pipeline failed.'
        }
    }
}
