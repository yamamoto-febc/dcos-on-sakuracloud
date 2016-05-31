module "bootstrap" {
    source = "github.com/terraform-for-sakuracloud-modules/centos"

    server_name = "dcos_bootstrap"
    disk_name = "dcos_bootstrap"
    zone = "tk1a"
    switch_ids = "${sakuracloud_switch.sw.id}"
    private_ip = "${var.private_ip.bootstrap}"
    ssh_keyfile = "${path.root}/keys/id_rsa"
    ssh_keyid = "${sakuracloud_ssh_key.key.id}"

    #spec
    core = 2
    memory = 4
    disk_size = 100
}

resource null_resource "bootstrap" {
    triggers = {
        target_id = "${module.bootstrap.server_id}"
        agent01_private_ip = "${module.agent01.private_ip}"
        agent02_private_ip = "${module.agent02.private_ip}"
        master01_private_ip = "${module.master01.private_ip}"
    }
    connection {
        user = "root"
        host = "${module.bootstrap.global_ip}"
        private_key = "${file("${path.root}/keys/id_rsa")}"
    }
  
    provisioner "file" {
        source = "${path.root}/provision/bootstrap.sh"
        destination = "/tmp/provision.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "mkdir genconf"
        ]
    }

    provisioner "file" {
        source = "${path.root}/provision/genconf/ip-detect"
        destination = "/root/genconf/ip-detect"
    }

    provisioner "remote-exec" {
        inline = [
            "mkdir genconf",
            "cat << EOF > genconf/config.yaml\n${template_file.config_yaml.rendered}\nEOF\n",
            "cat << EOF > genconf/ssh_key\n${file("${path.root}/keys/id_rsa")}\nEOF\n",
            "chmod 0600 genconf/ssh_key",
            "chmod +x /tmp/provision.sh",
            "/tmp/provision.sh"
        ]
    }
}

resource template_file "ip_detect" {
    template = "${file("${path.root}/provision/genconf/ip-detect")}"
}

resource template_file "config_yaml" {
    template = "${file("${path.root}/provision/genconf/config.yaml")}"
    vars { 
        agent01_private_ip = "${module.agent01.private_ip}"
        agent02_private_ip = "${module.agent02.private_ip}"
        master01_private_ip = "${module.master01.private_ip}"
    }
}

output "ssh_bootstrap" {
    value = "${module.bootstrap.ssh_command}"
}
output "global_ip_bootstrap" {
    value = "${module.bootstrap.global_ip}"
}
output "private_ip_bootstrap" {
    value = "${module.bootstrap.private_ip}"
}

output "dcos_exhibitor_url" {
    value = "http://${module.master01.global_ip}:8181/exhibitor/v1/ui/index.html"
}

output "dcos_dashboard_url" {
    value = "http://${module.master01.global_ip}/"
}
