output "keypair_pem" {
  value     = tls_private_key.rogiwara-terraform-key.private_key_pem
  sensitive = true
}

output "keypair_key_name" {
  value = aws_key_pair.rogiwara-terraform-key-pair.key_name
}

output "keypair_pem_filename" {
  value = local_sensitive_file.private-key.filename
}