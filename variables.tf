variable "token" {}

# CloudId
variable "cloud_id" {}
variable "folder_id" {}
variable "zone" {default = "ru-central1-a"}

variable instance_name {default = "linux-vm"}

# VM settings.
variable cores { default = 2 }
variable core_fraction { default = 20 }
variable memory { default = 2 }
variable boot_disk { default = "network-ssd" }
variable disk_size {
  default = 30
  validation {
    condition = var.disk_size >= 30
    error_message = "Disk size must be not less than 20Gb!"
  }
}

variable "ssh_keys" {
    type = map
    default = {
        file = "~/.ssh/id_ed25519.pub"
        user = "your_login"
    }
}
