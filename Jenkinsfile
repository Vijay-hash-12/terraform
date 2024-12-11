pipeline {
    agent any

    

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the GitHub repository
                git credentialsId: 'github-credentials-id', url: 'https://github.com/Vijay-hash-12/terraform.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Use Jenkins credentials to authenticate with Azure
                    withCredentials([
                        string(credentialsId: 'azure-client-id', variable: 'AZURE_CLIENT_ID'),
                        string(credentialsId: 'azure-client-secret', variable: 'AZURE_CLIENT_SECRET'),
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
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the changes using Terraform with auto-approval
                    // Always run `terraform apply` only if `plan` succeeded
                    sh 'terraform apply -auto-approve tfplan'
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
