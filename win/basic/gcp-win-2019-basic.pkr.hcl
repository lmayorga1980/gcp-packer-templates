packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "windows-ssh-example" {
  project_id = var.project_id
  source_image_project_id = ["windows-cloud"]
  source_image_family = "windows-2019"
  zone = "us-east4-a"
  disk_size = 50
  machine_type = "n1-standard-8"
  communicator = "ssh"
  ssh_username = var.packer_username
  ssh_password = var.packer_user_password
  ssh_timeout = "1h"
  tags = ["packer"]
  preemptible = true
  image_name = "gcp-win-2019-full-baseline"
  image_description = "GCP Windows 2019 Base Image"
  image_labels = {
      server_type = "windows-2019"
  }
  metadata = {
    windows-startup-script-cmd = "net user ${var.packer_username} \"${var.packer_user_password}\" /add /y & wmic UserAccount where Name=\"${var.packer_username}\" set PasswordExpires=False & net localgroup administrators ${var.packer_username} /add & powershell Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 & powershell Start-Service sshd & powershell Set-Service -Name sshd -StartupType 'Automatic' & powershell New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 & powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"Set-ExecutionPolicy -ExecutionPolicy bypass -Force\""
  }
  account_file = var.account_file_path

}

build {
  sources = ["sources.googlecompute.windows-ssh-example"]

  provisioner "powershell" {
    script = "../../scripts/install-features.ps1"
    elevated_user     = var.packer_username
    elevated_password = var.packer_user_password
  }
  provisioner "powershell" {
    inline          = [ "Write-Host \"Hello from PowerShell\""]
  }
}


