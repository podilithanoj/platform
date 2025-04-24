terraform {
  backend "s3" {
    bucket         = "glacade"
    key            = "java-app-1/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}