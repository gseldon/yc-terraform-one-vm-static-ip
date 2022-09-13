resource "yandex_vpc_address" "static_addr" {
  name = "static_adr"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

resource "random_id" "vm_name" {
    byte_length = 8
}

resource "yandex_compute_instance" "vm-1" {

  name        = "${var.instance_name}-${lower(random_id.vm_name.hex)}"
  platform_id = "standard-v3"

  resources {
    cores  = var.cores
    core_fraction = var.core_fraction
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id  = data.yandex_compute_image.container-image.id
      type      = var.boot_disk
      size      = var.disk_size
    }
  }

  network_interface {
    subnet_id = "${data.yandex_vpc_subnet.subnet.subnet_id}"
    nat       = true
    nat_ip_address = "${resource.yandex_vpc_address.static_addr.external_ipv4_address[0].address}"
  }

  metadata = {
    serial-port-enable = "0"
    user-data = data.template_file.this.rendered
  }
  
  scheduling_policy {
    preemptible = true
  }
}

data "template_file" "this" {
  template = file("${path.module}/files/cloud-config")

  vars = {
    username    = var.ssh_keys.user
    ssh_key     = "${file("${var.ssh_keys["file"]}")}"
    user_groups = "dev"
  }
}

data "yandex_vpc_subnet" "subnet" {
  subnet_id = "e9btnmmhvoun04qn82al"
}

data "yandex_compute_image" "container-image" {
  family = "container-optimized-image"
}

output vm-info {
  value       = {
    connect = join(" ", ["ssh ", "${var.ssh_keys["user"]}@${resource.yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}"])
  }
  sensitive   = false
  description = "Вывод информации о ВМ"
}
