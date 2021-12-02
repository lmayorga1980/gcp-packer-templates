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
  default   = ""
}

variable "win_packages" {
  type    = string
  default = "git,notepadplusplus,python3"
}

variable "ssh_pub_key" {
  type    = string
}

variable "ssh_key_file_path" {
  type    = string
}

variable "ssh_pub_key_path" {
  type = string
}