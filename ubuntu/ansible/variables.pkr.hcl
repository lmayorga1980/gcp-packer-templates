variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "account_file_path" {
  type = string
  description = "GCP Account File Path"
}

variable "package" {
  type = string
  description = "List of Packages"
  default = "vim"
}

variable "packages" {
  type = string
  description = "List of Packages"
  default = "vim,net-tools"
}


