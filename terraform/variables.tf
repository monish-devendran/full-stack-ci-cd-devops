variable "app_name" {
    type = string
}


#MongoDB-Atlas
variable "mongodbatlas_public_key" {
    type =string
}

variable "mongodbatlas_private_key" {
    type = string
}

variable "gcp_machine_type"{
    type = string
}

variable "atlas_project_id" {
    type = string
}

variable "atlas_user_password" {
    type = string
}

variable "cloudflare_api_token"{
    type = string
}

variable "domain_name"{
    type = string
}