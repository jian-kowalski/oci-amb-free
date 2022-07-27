// Nome do compartimento
variable "name" {
  type    = string
  default = "developer_tf"
}

// Descricao do compartimento
variable "description" {
  type    = string
  default = "Compartimento gerado pelo terraform"
}


/*
Available flex shapes:
"VM.Optimized3.Flex"  # Intel Ice Lake
"VM.Standard3.Flex"   # Intel Ice Lake
"VM.Standard.A1.Flex" # Ampere Altra
"VM.Standard.E3.Flex" # AMD Rome
"VM.Standard.E4.Flex" # AMD Milan
*/
// Instancia que sera utilizada
variable "shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

// Sistema operacional
variable "os" {
  type    = string
  default = "Canonical Ubuntu"
}

//Versão do sistema operacinal
variable "os_version" {
  type    = string
  default = "20.04"
}

// Numero de instancias que serão criadas
variable "num_instance" {
  type    = number
  default = 3
}

// Dominio de disponibilidade padrão
variable "availability_domain_default" {
  type    = number
  default = 0
}

//Numero de ocpus da instancia
variable "ocpus" {
  type    = number
  default = 1
}
//Memoria(GB) da instancia
variable "memoria_gb" {
  type    = number
  default = 6
}

variable "lb_polycy" {
  type    = string
  default = "ROUND_ROBIN"
}

// Retorna a primeira instancia (controplane)
variable "instance_default" {
  type    = number
  default = 1
}

variable "db_host" {
  type    = string
  default = "value"
}

variable "db_name" {
  type    = string
  default = "value"
}
variable "db_username" {
  type    = string
  default = "value"
}
variable "db_password" {
  type    = string
  default = "value"
}
