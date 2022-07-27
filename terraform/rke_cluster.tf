resource "rke_cluster" "cluster" {
  cluster_name          = "oci-cluster"
  kubernetes_version    = "v1.22.4-rancher1-1"
  disable_port_check    = false
  ignore_docker_version = false
  delay_on_creation     = 30
  addon_job_timeout     = 30
  nodes {
    address          = oci_core_instance.master.0.public_ip
    internal_address = oci_core_instance.master.0.private_ip
    user             = "ubuntu"
    ssh_key          = tls_private_key.ssh.private_key_pem
    role             = ["controlplane", "worker", "etcd"]
  }
  nodes {
    address          = oci_core_instance.node.0.public_ip
    internal_address = oci_core_instance.node.0.private_ip
    user             = "ubuntu"
    ssh_key          = tls_private_key.ssh.private_key_pem
    role             = ["worker", "etcd"]
  }
  nodes {
    address          = oci_core_instance.node.1.public_ip
    internal_address = oci_core_instance.node.1.private_ip
    user             = "ubuntu"
    ssh_key          = tls_private_key.ssh.private_key_pem
    role             = ["worker", "etcd"]
  }
  network {
    plugin = "flannel"
  }
  authorization {
    mode = "rbac"
  }
  ingress {
    provider = "none"
  }
  monitoring {
    provider = "none"
  }
  upgrade_strategy {
    drain                        = true
    max_unavailable_worker       = "20%"
    max_unavailable_controlplane = "1"
  }
}


resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}

resource "local_file" "rke_cluster_yaml" {
  filename = "${path.root}/cluster.yml"
  content  = rke_cluster.cluster.rke_cluster_yaml
}

resource "local_file" "rke_state" {
  filename = "${path.root}/cluster.rkestate"
  content  = rke_cluster.cluster.rke_state
}