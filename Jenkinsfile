pipeline {
    agent any

    environment {
        // Set empty placeholders for Terraform variables, which will be replaced later
        TF_VAR_subscription_id = ''  
        TF_VAR_client_id = ''        
        TF_VAR_client_secret = ''    
        TF_VAR_tenant_id = ''        
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
                        string(credentialsId: 'clientId', variable: 'AZURE_CLIENT_ID'),
                        string(credentialsId: 'clientSecret', variable: 'AZURE_CLIENT_SECRET'),
                        string(credentialsId: 'subscriptionId', variable: 'AZURE_SUBSCRIPTION_ID'),
                        string(credentialsId: 'tenantId', variable: 'AZURE_TENANT_ID')
                    ]) {
                        // Set environment variables for Terraform authentication inside the script block
                        bat """
                            set ARM_CLIENT_ID=%AZURE_CLIENT_ID%
                            set ARM_CLIENT_SECRET=%AZURE_CLIENT_SECRET%
                            set ARM_SUBSCRIPTION_ID=%AZURE_SUBSCRIPTION_ID%
                            set ARM_TENANT_ID=%AZURE_TENANT_ID%
                            terraform init
                        """
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Use the stored password secret securely
                    withCredentials([string(credentialsId: 'Password', variable: 'PASSWORD')]) {
                        // Ensure the password is passed securely without exposure in logs
                        bat "terraform plan -var=\"vm_admin_password=${PASSWORD}\""
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the Terraform changes with the password securely
                    withCredentials([string(credentialsId: 'Password', variable: 'PASSWORD')]) {
                        // Apply the configuration with -auto-approve to avoid manual intervention
                        bat "terraform apply -var=\"vm_admin_password=${PASSWORD}\" -auto-approve"
                    }
                }
            }
        }
    }
}
