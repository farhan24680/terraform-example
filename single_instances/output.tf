output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "instance_dns_name" {
  value = aws_instance.my_instance.public_dns
}
