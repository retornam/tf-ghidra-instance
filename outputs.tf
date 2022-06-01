output "private_key_pem" {
  value     = tls_private_key.keypem.private_key_pem
  sensitive = true
}

output "public_key_pem" {
  value     = tls_private_key.keypem.public_key_pem
  sensitive = true
}


output "public_key_openssh" {
  value     = tls_private_key.keypem.public_key_openssh
  sensitive = true
}


output "instance_ip" {
  value = aws_instance.ghidra.public_ip
}