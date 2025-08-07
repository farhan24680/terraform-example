output "instance_public_ips" {
  value = {
    for name, instance in aws_instance.my_instance :
    name => instance.public_ip
  }
}

output "instance_dns_names" {
  value = {
    for name, instance in aws_instance.my_instance :
    name => instance.public_dns
  }
}
