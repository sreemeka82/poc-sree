provider "vsphere" {
  user           = "admin"
  password       = "password"
  vsphere_server = "10.xxx"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}