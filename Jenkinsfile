pipeline {
    agent any

    environment {
        // Optional: Define any other environment variables you may need
        // These will be used by Terraform
        TF_VAR_subscription_id = 'cff5596b-0353-4056-9fcc-02fdcdd59e80'  // This will be replaced by Jenkins credentials
        TF_VAR_client_id = '8363189a-22ae-4730-b095-a60d0f41d98e'        // This will be replaced by Jenkins credentials
        TF_VAR_client_secret = 'secret'    // This will be replaced by Jenkins credentials
        TF_VAR_tenant_id = '4ca5d8fc-0c4d-444f-9d14-d74203e46373'        // This will be replaced by Jenkins credentials
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
                        string(credentialsId: 'azure-client-id', variable: 'AZURE_CLIENT_ID'),
                        string(credentialsId: 'secret', variable: 'AZURE_CLIENT_SECRET'),  // Corrected to 'secret'
                        string(credentialsId: 'azure-subscription-id', variable: 'AZURE_SUBSCRIPTION_ID'),
                        string(credentialsId: 'azure-tenant-id', variable: 'AZURE_TENANT_ID')
                    ]) {
                        // Set environment variables for Terraform authentication
                        sh '''
                            export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                            export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                            export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                            export ARM_TENANT_ID=$AZURE_TENANT_ID
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
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the changes using Terraform with auto-approval
                    sh 'terraform apply -auto-approve'
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
