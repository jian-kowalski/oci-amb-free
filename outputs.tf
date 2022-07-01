output "ssh-with-k8s-user" {
  value = format(
    "\nssh -o StrictHostKeyChecking=no -i %s -l %s %s\n",
    local_file.ssh_private_key.filename,
    "k8s",
    oci_core_instance.instance[1].public_ip
  )
}

//Após a execução, executa o laço printando a forma de acesso na instancia 
output "ssh-with-ubuntu-user" {
  value = join(
    "\n",
    [for i in oci_core_instance.instance :
      format(
        "ssh -o StrictHostKeyChecking=no -l ubuntu -p 22 -i %s %s # %s",
        local_file.ssh_private_key.filename,
        i.public_ip,
        i.display_name
      )
    ]
  )
}


output "lb_public_ip" {
  value = [oci_load_balancer_load_balancer.load_balancer.ip_address_details]
}

