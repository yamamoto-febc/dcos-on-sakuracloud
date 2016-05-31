variable "private_ip" {
    default = {
        "bootstrap" = "192.168.2.11"
        "master01" = "192.168.2.101"
        "agent01" = "192.168.2.201"
        "agent02" = "192.168.2.202"
    }
}

variable "spec" {
    default = {
        bootstrap_core = 2
        bootstrap_memory = 4
        
        master_core = 4
        master_memory = 8
        
        agent_core = 2
        agent_memory = 4
    }
}
