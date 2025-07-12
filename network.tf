resource "oci_core_vcn" "oci-vcn" {
  compartment_id = oci_identity_compartment.oci-compartment.id
  cidr_block     = var.vcn_cidr
  display_name   = "${var.prefix}-network"
  dns_label      = var.prefix
}

resource "oci_core_internet_gateway" "oci-internet-gateway" {
  compartment_id = oci_identity_compartment.oci-compartment.id
  vcn_id         = oci_core_vcn.oci-vcn.id
  display_name   = "${var.prefix}-internet-gateway"
  enabled        = "true"
}

resource "oci_core_subnet" "oci-subnet" {
  compartment_id = oci_identity_compartment.oci-compartment.id
  vcn_id         = oci_core_vcn.oci-vcn.id
  cidr_block     = var.vcn_cidr
  display_name   = "${var.prefix}-subnet"
}

resource "oci_core_default_route_table" "oci-route-table" {
  manage_default_resource_id = oci_core_vcn.oci-vcn.default_route_table_id
  route_rules {
    network_entity_id = oci_core_internet_gateway.oci-internet-gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_route_table_attachment" "oci-route-table-attach" {
  subnet_id      = oci_core_subnet.oci-subnet.id
  route_table_id = oci_core_vcn.oci-vcn.default_route_table_id
}

resource "oci_core_network_security_group" "oci-network-security-group" {
  compartment_id = oci_identity_compartment.oci-compartment.id
  vcn_id         = oci_core_vcn.oci-vcn.id
  display_name   = "${var.prefix}-network-security-group"
}

resource "oci_core_default_security_list" "oci-security-list" {
  manage_default_resource_id = oci_core_vcn.oci-vcn.default_security_list_id
  display_name               = "${var.prefix}-security"
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  # Ingress rules for SSH and WebUI
  ingress_security_rules {
    protocol = 6
    source   = var.mgmt_cidr
    tcp_options {
      max = "22"
      min = "22"
    }
  }
  # ingress_security_rules {
  #   protocol = 6
  #   # Restrict access to the Management IP only
  #   source = var.mgmt_cidr
  #   # Open to all
  #   # source = "0.0.0.0/0"
  #   tcp_options {
  #     max = var.web_port
  #     min = var.web_port
  #   }
  # }
  # ingress_security_rules {
  #   protocol = 6
  #   source   = "${oci_core_instance.oci-instance.public_ip}/32"
  #   tcp_options {
  #     max = var.web_port
  #     min = var.web_port
  #   }
  # }
}
