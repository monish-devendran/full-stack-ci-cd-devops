# Configure the Cloudflare provider.
# You may optionally use version directive to prevent breaking changes occurring unannounced.
provider "cloudflare" {
  token = var.cloudflare_api_token
}

#DNS-zone

#DNS A record for sub domanins :example.com and example.1.com


