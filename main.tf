terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.49.0"
    }
  }
}

provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = "zbs79ve8LCiITRiMSg3w7CeKuipr9iJh"
  auth_url    = "https://192.168.1.107:5000/v3/ "
  region      = "microstack"
  insecure = true
}

resource "openstack_images_image_v2" "cirros" {
  name             = "cirros"
  image_source_url = "https://download.cirros-cloud.net/0.6.1/cirros-0.6.1-x86_64-disk.img"
  container_format = "bare"
  disk_format      = "qcow2"

  properties = {
    key = "value"
  }
}

resource "openstack_networking_network_v2" "external-network" {
  name           = "external-network"
  admin_state_up = "true"
  external       = "true"
  segments {
    network_type     = "flat"
    physical_network = "new_physnet"
  }
}

resource "openstack_networking_subnet_v2" "external-subnet" {
  name            = "external-subnet"
  network_id      = openstack_networking_network_v2.external-network.id
  cidr            = "10.0.0.0/8"
  gateway_ip      = "10.0.0.2"
  dns_nameservers = ["10.0.0.254", "10.0.0.253"]
  allocation_pool {
    start = "10.0.0.3"
    end   = "10.0.254.254"
  }
}
resource "openstack_networking_router_v2" "external-router" {
  name                = "external-router"
  admin_state_up      = true
  external_network_id = openstack_networking_network_v2.external-network.id
}
