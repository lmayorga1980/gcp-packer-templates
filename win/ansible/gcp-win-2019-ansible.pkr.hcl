packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "windows-ssh-ansible" {
  project_id              = var.project_id
  source_image_project_id = ["windows-cloud"]
  source_image_family     = "windows-2019"
  zone                    = "us-east4-a"
  disk_size               = 50
  machine_type            = "n1-standard-8"
  communicator            = "ssh"
  ssh_username            = var.packer_username
  ssh_private_key_file    = var.ssh_key_file_path
  ssh_timeout             = "1h"
  tags                    = ["packer"]
  preemptible             = true
  image_name              = "gcp-win-2019-full-baseline"
  image_description       = "GCP Windows 2019 Base Image"
  image_labels = {
    server_type = "windows-2019"
  }
  metadata = {
    windows-startup-script-cmd = "net user ${var.packer_username} \"${var.packer_user_password}\" /add /y & wmic UserAccount where Name=\"${var.packer_username}\" set PasswordExpires=False & net localgroup administrators ${var.packer_username} /add & powershell Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 & echo ${var.ssh_pub_key} > C:\\ProgramData\\ssh\\administrators_authorized_keys & icacls.exe \"C:\\ProgramData\\ssh\\administrators_authorized_keys\" /inheritance:r /grant \"Administrators:F\" /grant \"SYSTEM:F\" & powershell New-ItemProperty -Path \"HKLM:\\SOFTWARE\\OpenSSH\" -Name DefaultShell -Value \"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe\" -PropertyType String -Force  & powershell Start-Service sshd & powershell Set-Service -Name sshd -StartupType 'Automatic' & powershell New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 & powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"Set-ExecutionPolicy -ExecutionPolicy bypass -Force\""
  }
  account_file = var.account_file_path

}

build {
  sources = ["sources.googlecompute.windows-ssh-ansible"]

  provisioner "ansible" {
    playbook_file           = "./playbooks/playbook.yml"
    use_proxy               = false
    ansible_ssh_extra_args  = ["-o StrictHostKeyChecking=no -o IdentitiesOnly=yes"]
    ssh_authorized_key_file = var.ssh_pub_key_path
    extra_arguments = ["-e", "win_packages=${var.win_packages}",
      "-e",
      "ansible_shell_type=powershell",
      "-e",
      "ansible_shell_executable=None"
    ]
    user = var.packer_username
  }

}


