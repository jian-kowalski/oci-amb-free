//Criação do compartimento
resource "oci_identity_compartment" "compartment" {
  name          = var.name
  description   = var.description
  enable_delete = true
}

locals {
  compartment_id = oci_identity_compartment.compartment.id
}

//Criação da VCN
resource "oci_core_vcn" "vcn" {
  compartment_id = local.compartment_id
  cidr_block     = "10.0.0.0/16"
}

//Cria um internet gateway
resource "oci_core_internet_gateway" "gateway" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
}

//Criação da tabela de roteamento padrão
resource "oci_core_default_route_table" "route_table" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.gateway.id
  }
}

//Cricao do security list
resource "oci_core_default_security_list" "security_list" {
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id
  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

//Criação da subnet
resource "oci_core_subnet" "subnet" {
  compartment_id    = local.compartment_id
  cidr_block        = "10.0.0.0/24"
  vcn_id            = oci_core_vcn.vcn.id
  route_table_id    = oci_core_default_route_table.route_table.id
  security_list_ids = [oci_core_default_security_list.security_list.id]
}

//Criação do load balancer
resource "oci_load_balancer_load_balancer" "load_balancer" {

  compartment_id = local.compartment_id
  display_name   = format("lb_%s", var.name)
  shape          = "flexible"
  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }

  subnet_ids = [
    oci_core_subnet.subnet.id,
  ]
}

//Criando o backend-set
resource "oci_load_balancer_backend_set" "load_balancer_backend_set" {
  name             = format("backend_set_%s", var.name)
  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  policy           = var.lb_polycy

  health_checker {
    protocol = "TCP"
    port     = "80"
  }
}



//Definindo o backend_set
resource "oci_load_balancer_backend" "backend_set" {
  count            = length(oci_core_instance.node)
  backendset_name  = oci_load_balancer_backend_set.load_balancer_backend_set.name
  ip_address       = oci_core_instance.node[count.index].private_ip
  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  port             = "80"
}



resource "oci_load_balancer_listener" "listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.load_balancer.id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.load_balancer_backend_set.name
  port                     = 80
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "120"
  }
}
