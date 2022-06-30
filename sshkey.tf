//Criação da chave ssh RSA
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

//Criação do arquivo local, contendo a chave privada, para acessar as instancias
resource "local_file" "ssh_private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "id_rsa"
  file_permission = "0600"
}

//Criação do arquivo local, contendo a chave publica, para acessar as instancias
resource "local_file" "ssh_public_key" {
  content         = tls_private_key.ssh.public_key_openssh
  filename        = "id_rsa.pub"
  file_permission = "0600"
}

// Chave publica, que sera definida nas instancias.
locals {
  public_key = [chomp(tls_private_key.ssh.public_key_openssh)]
}
