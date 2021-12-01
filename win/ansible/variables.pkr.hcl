variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "account_file_path" {
  type        = string
  description = "GCP Account File Path"
}

variable "packer_username" {
  type    = string
  default = "packer_user"
}

variable "packer_user_password" {
  type      = string
  sensitive = true
  default   = "=|i3FdD3,{C<:^n"
}

variable "win_packages" {
  type    = string
  default = "git,notepadplusplus,python3"
}

variable "ssh_pub_key" {
  type    = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpVcqCItUvRwSe6l/Zv8tuSlIP7fQDh4C8kdvclXTEg lmayorga@lcentinel88.local"
}

variable "ssh_key_file_path" {
  type    = string
  default = "/Users/lmayorga/.ssh/packer_gcp_key"
}