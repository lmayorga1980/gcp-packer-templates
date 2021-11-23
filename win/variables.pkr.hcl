variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "account_file_path" {
  type = string
  description = "GCP Account File Path"
}

variable "packer_username" {
  type = string
  default = "packer_user"
}

variable "packer_user_password" {
  type = string
  sensitive = true
  default = "=|i3FdD3,{C<:^n"
}