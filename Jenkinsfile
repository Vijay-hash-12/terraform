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
                    // Use the correct -var syntax, and securely pass the password as a variable
                    withCredentials([string(credentialsId: 'Password', variable: 'Password')]) {
                        bat "terraform plan -var=\"vm_admin_password=${Password}\""
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the Terraform changes with the correct password
                    withCredentials([string(credentialsId: 'Password', variable: 'Password')]) {
                        bat "terraform apply -var=\"vm_admin_password=${Password}\" -auto-approve"
                    }
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
