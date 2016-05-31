module "agent02" {
    source = "github.com/terraform-for-sakuracloud-modules/centos"

    server_name = "dcos_agent02"
    disk_name = "dcos_agent02"
    zone = "tk1a"
    switch_ids = "${sakuracloud_switch.sw.id}"
    private_ip = "${var.private_ip.agent02}"
    ssh_keyfile = "${path.root}/keys/id_rsa"
    ssh_keyid = "${sakuracloud_ssh_key.key.id}"

    #spec
    core = "${var.spec.agent_core}"
    memory = "${var.spec.agent_memory}"
    disk_size = 100
}

resource null_resource "agent02" {
    triggers = {
        target_id = "${module.agent02.server_id}"
    }
    connection {
        user = "root"
        host = "${module.agent02.global_ip}"
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

output "ssh_agent02" {
    value = "${module.agent02.ssh_command}"
}
output "global_ip_agent02" {
    value = "${module.agent02.global_ip}"
}
output "private_ip_agent02" {
    value = "${module.agent02.private_ip}"
}
