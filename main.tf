# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

# Create a new tag
resource "digitalocean_tag" "mail" {
  name = "${var.tag}"
}

data "template_file" "user-data" {
  template = "${file("./user-data.yml")}"

  vars {
    mounts = "${var.volume_name}"
    domain = "${var.domain}"
    database_password = "${var.database_password}"
  }
}

resource "digitalocean_volume" "storage" {
  region      = "${var.region}"
  name        = "${var.name}-volume"
  size        = "${var.volume_size}"
  description = "${var.volume_description}"
}

resource "digitalocean_droplet" "mail" {
  image  = "${var.image}"
  name   = "${var.name}"
  region = "${var.region}"
  size   = "${var.instance_size}"
  volume_ids = ["${digitalocean_volume.storage.id}"]
  tags = ["${digitalocean_tag.mail.id}"]
}

resource "digitalocean_firewall" "web" {
  name = "${var.name}-server"

  droplet_ids = ["${digitalocean_droplet.mail.d}"]
  tags = ["${digitalocean_tag.mail.id}"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["${var.ssh_ingress_address}"]
    },
    {
      protocol           = "tcp"
      port_range         = "80"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "443"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "143"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "465"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "25"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "587"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "993"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "4190"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    }
  ]

  outbound_rule {
    protocol                = "udp"
    port_range              = "53"
    destination_addresses   = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_floating_ip" "foobar" {
  droplet_id = "${digitalocean_droplet.mail.id}"
  region     = "${digitalocean_droplet.mail.region}"
}