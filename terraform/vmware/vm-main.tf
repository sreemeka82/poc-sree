# Data for Resources
data "vsphere_datacenter" "dc" {
  name = "EXX_CXX"
}
data "vsphere_datastore" "datastore" {
  name          = "DXX_CXX_P1_1XX"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_compute_cluster" "cluster" {
  name          = "CXX_MF_CXX"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_resource_pool" "pool" {
  name = "RP_CXX_TEST"
  #name          = "CXX_MF_CXX/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_resource_pool" "target-resource-pool" {
  name          = "CXX_MF_CXX/Resources/RP_CXX_TEST"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name          = "DXX_CXX_711_ADMIN"
  datacenter_id = data.vsphere_datacenter.dc.id
}
#Data source for VM template
data "vsphere_virtual_machine" "template" {
  name          = "winss2019"
  datacenter_id = data.vsphere_datacenter.dc.id
}
#Build VM
resource "vsphere_virtual_machine" "vm" {
  name             = "test2019"
  resource_pool_id = data.vsphere_resource_pool.target-resource-pool.id
  #resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id = data.vsphere_datastore.datastore.id
  num_cpus     = 3
  memory       = 8192
  guest_id     = data.vsphere_virtual_machine.template.guest_id
  scsi_type    = data.vsphere_virtual_machine.template.scsi_type
  network_interface {
    network_id = data.vsphere_network.network.id
    #adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label = "disk0"
    size  = data.vsphere_virtual_machine.template.disks.0.size
    #eagerly_scrub    = true #"${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    #thin_provisioned = false
  }
  disk {
    label            = "disk1"
    size             = 10
    eagerly_scrub    = true #"${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = false
    unit_number      = 1
  }
  disk {
    label            = "disk2"
    size             = 10
    eagerly_scrub    = true #"${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = false
    unit_number      = 2
  }
  run_tools_scripts_before_guest_shutdown = true
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      windows_options {
        computer_name = "terraform-win"
        #domain = "fXXX.XXnet"
        join_domain           = "fXX.XXnet"
        domain_admin_user     = "admin@fXXX.XXnet"
        domain_admin_password = "PASSWORD"
        admin_password        = "123456789"
      }
      network_interface {
        ipv4_address = "10.xx.1x.3"
        ipv4_netmask = 24
      }
      ipv4_gateway = "10.2XX.1X.1"
      #servers
      dns_server_list = ["10.2XX.9.1XX"]
      #dns_suffix_list = ["10.2XX.9.1X"]
    }
  }
  connection {
    type     = "winrm"
    host     = "0.2XX.1X.1"
    user     = "administrator"
    password = "123456789"
    agent    = false
  }
  provisioner "file" {
    source      = "D:/test/script/"
    destination = "C:/Temp/"
  }

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -ExecutionPolicy Bypass -File C:/Temp/partion.ps1"      
      
    ]
  }
}

