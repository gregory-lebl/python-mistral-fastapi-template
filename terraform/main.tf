# Define required providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  # I use the openrc file
}

resource "openstack_compute_keypair_v2" "keypair_wsl" {
  name       = "keypair_wsl"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIsZAU6cSNVw/LSVwti4Nv/esthmpwgmXll+16pg5nh6 gregory.leblond.dev@gmail.com"
}

# Create a web security group
resource "openstack_compute_secgroup_v2" "web_server" {
  name        = "web_server"
  description = "Security Group Description"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

# Create a web server
resource "openstack_compute_instance_v2" "web-server" {
  name            = "web-server"
  image_id        = "94695576-2f7e-4686-9c36-7dd95e35ef9a" # Debian 12
  flavor_name     = "d2-2"
  key_pair        = "keypair_wsl"
  security_groups = ["web_server"]

  metadata = {
    application = "web-app"
  }

  network {
    name = "Ext-Net"
  }

  provisioner "local-exec" {
    command = "printf '[default]\n${self.network.0.fixed_ip_v4} ansible_ssh_user=debian ansible_ssh_private_key_file=~/.ssh/id_ed25519' >> ../ansible/hosts && ssh-keyscan ${self.network.0.fixed_ip_v4} >> ~/.ssh/known_hosts && cd ../ansible && ansible-playbook -i hosts playbook.yml"
  }
}

output "instance_ip" {
  value = openstack_compute_instance_v2.web-server.network.0.fixed_ip_v4
}


