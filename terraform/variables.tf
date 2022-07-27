variable "tenancy_ocid" {
  type        = string
  description = "Id do Tenancy"
  default     = ""
}

variable "user_ocid" {
  type        = string
  description = "Id do User"
  default     = ""
}

variable "fingerprint" {
  type        = string
  description = "Impressão Digital da chave publica"
  default     = ""
}

variable "private_key_path" {
  type        = string
  description = "Path na sua maquina onde fica a chave privada .pem"
  default     = ""
}

variable "region" {
  type        = string
  description = "Região na qual será criado os recursos"
  default     = "sa-saopaulo-1"
}

variable "name" {
  type    = string
  default = "developer_tf"
}

variable "description" {
  type    = string
  default = "Compartimento gerado pelo terraform"
}

variable "shape" {
  default = "VM.Standard.A1.Flex"
}
variable "time_zone" {
  type    = string
  default = "America/Sao_Paulo"
}
variable "lb_polycy" {
  type    = string
  default = "ROUND_ROBIN"
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

variable "VOLUME_ATTACHMENT_ATTACHMENT_TYPE" {
  default = "paravirtualized"
}
variable "CIDR_VCN01" {
  default = "10.0.0.0/16"
}
variable "CIDR_SUBNET01" {
  default = "10.0.0.0/24"
}
variable "CIDR_SUBNET02" {
  default = "10.0.1.0/24"
}
variable "CIDR_VCN02" {
  default = "192.168.0.0/16"
}
variable "CIDR_SUBNET03" {
  default = "192.168.0.0/24"
}
variable "os_user" {
  default = "ubuntu"
}

// Dominio de disponibilidade padrão
variable "availability_domain_default" {
  type    = number
  default = 0
}

