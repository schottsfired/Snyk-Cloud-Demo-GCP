resource "google_compute_instance" "vuln_vm" {
  name         = "${var.owner}gcpvm"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "${var.owner}gcpnic"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

    metadata_startup_script = "#!/bin/bash until sudo apt-get update && sudo apt-get -y install nginx;do sleep 1 done;  until sudo apt-get -y install docker.io;do sleep 1 done; until sudo docker pull bkimminich/juice-shop;do sleep 1 done; sudo service nginx stop; sudo docker run --rm -d -p 3000:3000 bkimminich/juice-shop:latest;ip_address=$(dig +short myip.opendns.com @resolver1.opendns.com);  sudo touch /etc/nginx/conf.d/juice.conf sudo chmod a+w /etc/nginx/conf.d/juice.conf; sudo cat <<EOT >> /etc/nginx/conf.d/juice.conf server { listen 80; listen [::]:80; server_name $ip_address; location / { proxy_pass http://localhost:3000/; } } EOT; sudo service nginx restart; sleep 2; sudo nginx -s reload dir=home/ubuntu/l;"

    // Apply the firewall rule to allow external IPs to access this instance
    tags = ["http-server"]
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "3389", "22"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

