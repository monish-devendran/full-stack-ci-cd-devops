provider "google" {
    credentials = file("terraform-key.json")
    project = "extended-legend-300803"
    region = "us-central1"
    zone = "us-central1-c"
}

#IP address
resource "google_compute_address" "ip_address" {
  name = "storybook-app-${terraform.workspace}"
}


#network
#use existing network by using data block
data "google_compute_network" "default"{
    name = "default"
}


#firewall rule
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-${terraform.workspace}"
  network = data.google_compute_network.default.name

  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  source_tags = ["web"]

  #target tags can attach the vm to the firewall rule
  target_tags  = ["allow-http-${terraform.workspace}"]
}



#os image
# container optimized OS built by google specificaly built to run containers
#note does not include package manager any software should be handled at container level
data "google_compute_image" "cos_image"{
    family = "cos-81-lts"
    project = "cos-cloud"
}

#vm instance

resource "google_compute_instance" "instance" {
  name         = "${var.app_name}-vm-${terraform.workspace}"
  machine_type = var.gcp_machine_type
  zone         = "us-central1-a"

  tags = google_compute_firewall.allow_http.target_tags

  boot_disk {
    initialize_params {
      image = data.google_compute_image.cos_image.self_link
    }
  }

  
  network_interface {
    network = data.google_compute_network.default.name

    access_config {
      // Ephemeral IP
      nat_ip = google_compute_address.ip_address.address
    }
  }


  service_account {
      #read docker image from google container registry
    scopes = ["storage-ro"]
  }
}