
// Configurações das instancias
data "oci_core_images" "arm" {
  compartment_id           = local.compartment_id
  shape                    = var.shape
  operating_system         = var.os
  operating_system_version = var.os_version
}

//lista de Domínios de Disponibilidade 
data "oci_identity_availability_domains" "domains" {
  compartment_id = local.compartment_id
}

data "template_file" "cloud_config_node" {
  template = <<YAML
#cloud-config
timezone: ${var.time_zone}
locale: en_US.utf8
runcmd:
- apt-get update
- apt-get install -y dnsutils jq
- sysctl -w net.ipv4.ip_forward=1
- sed -i -e "s/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
- iptables -F
- iptables -I FORWARD 1 -i ens3 -o ens3 -j ACCEPT
- iptables -t nat -A POSTROUTING -o ens3 -s ${var.CIDR_SUBNET01} -j MASQUERADE
YAML
}