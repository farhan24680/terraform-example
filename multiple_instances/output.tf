output "instance_public_ips" {
  value = [for instance in aws_instance.my_instance : instance.public_ip]
}

output "instance_dns_names" {
  value = [for instance in aws_instance.my_instance : instance.public_dns]
}

