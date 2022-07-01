//Criação do compartimento
resource "oci_identity_compartment" "compartment" {
  name          = var.name
  description   = var.description
  enable_delete = true
}

//Variavel local, para armazenar o id do compartimento
locals {
  compartment_id = oci_identity_compartment.compartment.id
}

//lista de Domínios de Disponibilidade 
data "oci_identity_availability_domains" "domains" {
  compartment_id = local.compartment_id
}

// Configurações das instancias
data "oci_core_images" "image" {
  compartment_id           = local.compartment_id
  shape                    = var.shape
  operating_system         = var.os
  operating_system_version = var.os_version
}


// Laço utilizado para criar varias maquinas, retornando o nome do node, o Ip e regra do kubernetes
locals {
  instances = {
    for i in range(1, 1 + var.num_instance) :
    i => {
      node_name  = format("node%d", i)
      ip_address = format("10.0.0.%d", 10 + i)
      role       = i == 1 ? "controlplane" : "worker"
    }
  }
}

// Criação das instancias 
resource "oci_core_instance" "instance" {
  for_each            = local.instances
  display_name        = each.value.node_name
  availability_domain = data.oci_identity_availability_domains.domains.availability_domains[var.availability_domain_default].name
  compartment_id      = local.compartment_id
  shape               = var.shape

  shape_config {
    memory_in_gbs = var.memoria_gb
    ocpus         = var.ocpus
  }

  source_details {
    source_id   = data.oci_core_images.image.images[0].id
    source_type = "image"
  }

  create_vnic_details {
    subnet_id  = oci_core_subnet.subnet.id
    private_ip = each.value.ip_address
  }

  metadata = {
    ssh_authorized_keys = join("\n", local.public_key)
    user_data           = data.cloudinit_config.k8s_config[each.key].rendered
  }
}