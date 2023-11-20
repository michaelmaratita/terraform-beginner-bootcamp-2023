## Terrahome AWS

The public directory expects the following:
- index.html
- error.html
- assets

All top level files in assets will be copied but not any subdirectories

```
module "home_naruto" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.naruto_public_path
  content_version = var.content_version
}
```