module "agent01" {
    source = "github.com/terraform-for-sakuracloud-modules/centos"

    server_name = "dcos_agent01"
    disk_name = "dcos_agent01"
    zone = "tk1a"
    switch_ids = "${sakuracloud_switch.sw.id}"
    private_ip = "${var.private_ip.agent01}"
    ssh_keyfile = "${path.root}/keys/id_rsa"
    ssh_keyid = "${sakuracloud_ssh_key.key.id}"

    #spec
    core = "${var.spec.agent_core}"
    memory = "${var.spec.agent_memory}"
    disk_size = 100
}

resource null_resource "agent01" {
    triggers = {
        target_id = "${module.agent01.server_id}"
    }
    connection {
        user = "root"
        host = "${module.agent01.global_ip}"
        private_key = "${file("${path.root}/keys/id_rsa")}"
    }
  
    provisioner "file" {
        source = "${path.root}/provision/agent.sh"
        destination = "/tmp/provision.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/provision.sh",
            "/tmp/provision.sh"
        ]
    }
}

output "ssh_agent01" {
    value = "${module.agent01.ssh_command}"
}
output "global_ip_agent01" {
    value = "${module.agent01.global_ip}"
}
output "private_ip_agent01" {
    value = "${module.agent01.private_ip}"
}
