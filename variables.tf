variable "private_ip" {
    default = {
        "bootstrap" = "192.168.2.11"
        "master01" = "192.168.2.101"
        "agent01" = "192.168.2.201"
        "agent02" = "192.168.2.202"
    }
}
