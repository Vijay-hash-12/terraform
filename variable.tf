# Declare the Password variable
variable "Password" {
  description = "The password for the VM admin user"
  type        = string
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

