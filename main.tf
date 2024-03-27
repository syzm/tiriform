provider "google" {
  project = "zeta-sol-412413"
  region  = "europe-central2"
  zone    = "europe-central2-b"
}

resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "n2-standard-2"
  zone         = "europe-central2-b"

  tags = ["my-network-tag"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx

    cat <<HTML > /var/www/html/index.html
    <!DOCTYPE html>
    <html>
    <head>
      <title>Welcome to My Website</title>
    </head>
    <body>
      <h1>Hello, World!</h1>
      <p>This is a sample webpage served by Nginx on Google Cloud Platform.</p>
    </body>
    </html>
    HTML

    service nginx start
    EOF
}

resource "google_compute_firewall" "http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["my-network-tag"]
}
