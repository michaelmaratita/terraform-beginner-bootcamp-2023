terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  cloud {
    organization = "mmaratita-org"

    workspaces {
      name = "terra-house-1"
    }
  }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_destiny_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.destiny.public_path
  content_version = var.destiny.content_version
}

resource "terratowns_home" "home_destiny" {
  name = "What is Destiny 2"
  description = <<DESCRIPTION
Destiny is a free to play First Person Shooter (FPS) created by Bungie.
It consists of extensive lore, PvE and PvP content. This is why I like
to play Destiny 2!
DESCRIPTION
  domain_name = module.home_destiny_hosting.domain_name
  town = "gamers-grotto"
  content_version = var.destiny.content_version
}

module "home_naruto_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.naruto.public_path
  content_version = var.naruto.content_version
}
resource "terratowns_home" "home_naruto" {
  name = "Naruto"
  description = <<DESCRIPTION
Naruto" follows the journey of Naruto Uzumaki, a determined young ninja ostracized by his village due to the sealed Nine-Tailed Fox spirit within him. 
Despite facing adversity, Naruto aspires to become the strongest ninja and earn the title of Hokage. 
DESCRIPTION
  domain_name = module.home_naruto_hosting.domain_name
  town = "video-valley"
  content_version = var.naruto.content_version
}