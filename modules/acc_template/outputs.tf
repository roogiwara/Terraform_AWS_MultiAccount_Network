output "subnet_public1_id" {
  value = aws_subnet.rogiwara_public1.id
}

output "subnet_public2_id" {
  value = aws_subnet.rogiwara_public2.id
}

output "subnet_public3_id" {
  value = aws_subnet.rogiwara_public3.id
}

output "security_group_id" {
  value = aws_security_group.rogiwara_sg.id
}

output "module_name_path" {
  value = path.module
}