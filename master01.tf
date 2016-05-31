module "master01" {
    source = "github.com/terraform-for-sakuracloud-modules/centos"

    server_name = "dcos_master01"
    disk_name = "dcos_master01"
    zone = "tk1a"
    switch_ids = "${sakuracloud_switch.sw.id}"
    private_ip = "${var.private_ip.master01}"
    ssh_keyfile = "${path.root}/keys/id_rsa"
    ssh_keyid = "${sakuracloud_ssh_key.key.id}"

    #spec
    core = "${var.spec.master_core}"
    memory = "${var.spec.master_memory}"
    disk_size = 100
}

resource null_resource "master01" {
    triggers = {
        target_id = "${module.master01.server_id}"
    }
    connection {
        user = "root"
        host = "${module.master01.global_ip}"
        private_key = "${file("${path.root}/keys/id_rsa")}"
    }
  
    provisioner "file" {
        source = "${path.root}/provision/master.sh"
        destination = "/tmp/provision.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/provision.sh",
            "/tmp/provision.sh"
        ]
    }
}

output "ssh_master01" {
    value = "${module.master01.ssh_command}"
}
output "global_ip_master01" {
    value = "${module.master01.global_ip}"
}
output "private_ip_master01" {
    value = "${module.master01.private_ip}"
}
