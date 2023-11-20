variable "terratowns_access_token" {
  type = string
}
variable "terratowns_endpoint" {
  type = string
}
variable "teacherseat_user_uuid" {
  type = string
}

variable "destiny" {
  type = object({
    public_path = string
    content_version = number 
  })
}

variable "naruto" {
  type = object({
    public_path = string
    content_version = number 
  })
}

