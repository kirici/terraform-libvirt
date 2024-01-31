resource "libvirt_volume" "centos-stream8-qcow2" {
  name = "centos-stream8.qcow2"
  pool = "default"
  # source = "https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-latest.x86_64.qcow2"
  source = "./CentOS-Stream-GenericCloud-8-latest.x86_64.qcow2"
  format = "qcow2"
}

resource "libvirt_domain" "centos-stream8" {
  name       = "centos-stream8"
  memory     = "8192"
  vcpu       = 4
  qemu_agent = true

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.centos-stream8-qcow2.id}"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "ip" {
  value = "${libvirt_domain.centos-stream8.network_interface.0.addresses.0}"
}
