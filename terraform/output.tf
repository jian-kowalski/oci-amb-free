
output "private_ips" {
  value = [
    oci_core_instance.master.*.private_ip,
    oci_core_instance.node.*.private_ip
  ]
  description = "Private IPs of instances"
}

output "public_ips" {
  value = [
    oci_core_instance.master.*.public_ip,
    oci_core_instance.node.*.public_ip
  ]
  description = "Public IPs of instances"
}