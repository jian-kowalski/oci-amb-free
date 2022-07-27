#arm 4CPU 24G
resource "oci_core_instance" "node" {
  count               = 2
  availability_domain = data.oci_identity_availability_domains.domains.availability_domains[var.availability_domain_default].name
  compartment_id      = local.compartment_id
  shape               = var.shape
  display_name        = "node0${count.index + 1}"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }
  create_vnic_details {
    subnet_id              = oci_core_subnet.subnet.id
    assign_public_ip       = true
    skip_source_dest_check = false
  }
  source_details {
    source_id   = data.oci_core_images.arm.images[0].id
    source_type = "image"
  }
  metadata = {
    ssh_authorized_keys = join("\n", local.public_key)
    user_data           = "${base64encode(data.template_file.cloud_config_node.rendered)}"
  }
  timeouts {
    create = "60m"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.os_user
      host        = self.public_ip
      private_key = tls_private_key.ssh.private_key_pem
      timeout     = "5m"
    }
    scripts = [
      "provisioning/provisioning.sh",
    ]
  }
}
resource "oci_core_instance" "master" {
  count               = 1
  availability_domain = data.oci_identity_availability_domains.domains.availability_domains[var.availability_domain_default].name
  compartment_id      = local.compartment_id
  shape               = var.shape
  display_name        = "master0${count.index + 1}"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.subnet.id
    assign_public_ip       = true
    skip_source_dest_check = false
  }
  source_details {
    source_id   = data.oci_core_images.arm.images[0].id
    source_type = "image"
  }
  metadata = {
    # ssh_authorized_keys = "${file(var.SSH_PUBLIC_KEY_PATH)}"
    ssh_authorized_keys = join("\n", local.public_key)
    user_data           = "${base64encode(data.template_file.cloud_config_node.rendered)}"
  }
  timeouts {
    create = "60m"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.os_user
      host        = self.public_ip
      private_key = tls_private_key.ssh.private_key_pem
      timeout     = "5m"
    }
    scripts = [
      "provisioning/provisioning.sh",
    ]
  }
}