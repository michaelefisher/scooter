# set via -var="do_token=..." environment variable
variable "do_token" {}

variable "tag" {
    default = "mail"
}

variable "image" {
    default = "docker-16-04"
}

variable "name" {
    default = "scooter"
}

variable "region" {
    default = "nyc1"
}

variable "instance_size" {
    default = "3gb"
}

variable "volume_size" {
    default = 25
}

variable "volume_description" {
    default = "Persistent file storage for email"
}

variable "volume_name" {
    default = "volume-nyc3-01"
}

variable "domain" {
    default = "michaelfisher.org"
}

variable "database_password" {}

variable "ssh_ingress_address" {
    default = "108.41.152.69/32"
}
