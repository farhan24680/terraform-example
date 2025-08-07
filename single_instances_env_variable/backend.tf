terraform {
  backend "s3" {
    bucket         = "terraform-practice-abc"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform_practice_abc"
  }
}