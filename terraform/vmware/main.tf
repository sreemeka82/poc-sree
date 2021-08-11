# Data for Resources
data "vsphere_datacenter" "dc" {
  name = "${var.dc_name}"
}
data "vsphere_datastore" "datastore" {
  name          = "${var.datastore_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_compute_cluster" "cluster" {
  name          = "${var.nameofcluster}"
  #datacenter_id = data.vsphere_datacenter.dc.id
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_resource_pool" "pool" {
  name = "${var.resource_pool}"
  #name          = "clustername/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_resource_pool" "target-resource-pool" {
  name          = "${var.nameofcluster}/Resources/${var.resource_pool}"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name          = "${var.network_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}
#Data source for VM template
data "vsphere_virtual_machine" "template" {
  name          = "${var.template_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}
#Build VM
resource "vsphere_virtual_machine" "vm" {
  name             = "${var.buildvm_name}"
  #resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  resource_pool_id = data.vsphere_resource_pool.target-resource-pool.id
  #resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id = data.vsphere_datastore.datastore.id
  num_cpus     = "${var.num_cpus}"
  memory       = "${var.memory}"
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
    size             = "${var.disk1}"
    eagerly_scrub    = true #"${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = false
    unit_number      = 1
  }
  disk {
    label            = "disk2"
    size             = "${var.disk2}"
    eagerly_scrub    = true #"${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = false
    unit_number      = 2
  }
  run_tools_scripts_before_guest_shutdown = true
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      windows_options {
        computer_name = "${var.computer_name}"
        #domain = "frmon.danet"
        join_domain           = "${var.join_domain}"
        domain_admin_user     = "${var.domain_admin_user}"
        domain_admin_password = "${var.domain_admin_password}"
        admin_password        = "${var.admin_password}"
      }
      network_interface {
        ipv4_address = "${var.ipv4_address}"
        ipv4_netmask = 24
      }
      ipv4_gateway = "${var.ipv4_gateway}"
      #servers
      dns_server_list = "${var.dns_server_list}"
      #dns_suffix_list = ["X.X.X.X"]
    }
  }
  connection {
    type     = "winrm"
    host     = "${var.ipv4_address}"
    user     = "${var.user}"
    password = "${var.admin_password}"
    agent    = false
  }
  provisioner "file" {
    source      = "E:/ss/script/"
    destination = "C:/Temp/"
  }

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -ExecutionPolicy Bypass -File C:/Temp/partion.ps1",
      "powershell.exe -ExecutionPolicy Bypass -File C:/Temp/sep.ps1",
      "powershell.exe -ExecutionPolicy Bypass -File C:/Temp/ITM6_AutoInstall/Silent_Install.ps1"
           
    ]
  }
}

