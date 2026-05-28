data "terraform_remote_state" "infra" {
  backend = "s3" 
  config = {
    bucket = "kelvin-terraform-state-permanent"
    key    = "infra/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
