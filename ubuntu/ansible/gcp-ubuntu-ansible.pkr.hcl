packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "ubuntu-ansible" {
  project_id = var.project_id
  source_image_project_id = ["ubuntu-os-pro-cloud"]
  source_image_family = "ubuntu-pro-1804-lts"
  ssh_username = "ubuntu"
  machine_type = "g1-small"
  zone = "us-east4-b"
  image_name = "ubuntu-custom-2"
  image_description = "custom ubuntu image"
  disk_size = 10
  preemptible = true
  tags = ["packer","image"]
  image_labels = {
    built_by = "packer"
  }
  account_file = var.account_file_path
}

build {
  name = "ubuntu-custom-2"
  sources = [
    "sources.googlecompute.ubuntu-ansible"
  ]

  provisioner "ansible" {
    playbook_file = "./playbooks/playbook.yml"
    extra_arguments = ["--extra-vars","packages=${var.packages}"]

  }
 }
