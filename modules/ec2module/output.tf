output "output_ec2_id" {
    value = aws_instance.myec2.id
  }

output "output_ec2_AZ" {
  value = aws_instance.myec2.availability_zone
}