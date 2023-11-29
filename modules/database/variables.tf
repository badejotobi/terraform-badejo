variable "username" {
    type =string
default = "ocean"
}
variable "password" {
    type =string
default = "DataOceanPass"
sensitive = true
}
variable "identifier" {
    type =string
default = "oceanic"
}
variable "priv1" {}
variable "priv2" {}
variable "secgrp" {}
