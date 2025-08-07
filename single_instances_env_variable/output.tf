output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "instance_dns_name" {
  value = aws_instance.my_instance.public_dns
}

output "instances_volume_size" {
  value = aws_instance.my_instance.root_block_device[0].volume_size
}