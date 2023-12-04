output "output_eip" {
  value = aws_eip.my_ei.public_ip
}

output "output_eip_id" {
  value = aws_eip.my_ei.id
}