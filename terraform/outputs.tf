output "instance_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.web_server.public_ip
}
