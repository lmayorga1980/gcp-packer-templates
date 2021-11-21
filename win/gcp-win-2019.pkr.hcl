variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "account_file_path" {
  type = string
  description = "GCP Account File Path"
}

source "googlecompute" "windows-example" {
  project_id = var.project_id
  source_image_project_id = ["windows-cloud"]
  source_image_family = "windows-2019"
  #source_image = "windows-server-2019-dc-v20200813"
  zone = "us-east4-a"
  disk_size = 50
  machine_type = "n1-standard-2"
  communicator = "winrm"
  winrm_username = "packer_user"
  winrm_insecure = true
  winrm_use_ssl = true
  preemptible = true
  image_labels = {
      server_type = "windows-2019"
  }
  metadata = {
    windows-startup-script-cmd = "winrm quickconfig -quiet & net user /add packer_user & net localgroup administrators packer_user /add & winrm set winrm/config/service/auth @{Basic=\"true\"}"
  }
  account_file = var.account_file_path
}

build {
  sources = ["sources.googlecompute.windows-example"]
}