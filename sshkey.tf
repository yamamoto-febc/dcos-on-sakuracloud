resource "sakuracloud_ssh_key" "key" {
  name = "dcos_sshkey"
  public_key = "${file("${path.root}/keys/id_rsa.pub")}"
}
