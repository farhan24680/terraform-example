#this is s3 bucket 

resource "aws_s3_bucket" "remote_s3" {
  bucket = "terraform-practice-abc"

  tags = {
    Name        = "terraform-practice-abc"
  }
}