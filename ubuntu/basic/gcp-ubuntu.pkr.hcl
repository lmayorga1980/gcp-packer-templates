packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}


source "googlecompute" "ubuntu-custom" {
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
    "sources.googlecompute.ubuntu-custom"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]

    inline = [
      "echo Installing Redis",
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y redis-server",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  provisioner "shell" {
    inline = ["echo This provisioner runs last"]
  }
}
