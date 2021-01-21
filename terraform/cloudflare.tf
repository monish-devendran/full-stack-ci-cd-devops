# Configure the Cloudflare provider.
# You may optionally use version directive to prevent breaking changes occurring unannounced.
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

#DNS-zone
data "cloudflare_zones" "cf_zones" {
  filter {
    name = var.domain_name
  }
}

#DNS A record for sub domanins :example.com and example.1.com

# Add a record to the domain
resource "cloudflare_record" "foobar" {
  zone_id = data.cloudflare_zone_id.cf_zones.zones[0].id
  name    = "storybooks${terraform.worspace == "prod" ? "" : "-${terraform.workspace}"}"
  value   = google_compute_address.ip_address.address
  type    = "A"
  ttl     = 3600
}



