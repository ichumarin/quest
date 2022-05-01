output "quest_ec2_publicIP" {
  value = "Quest on EC2 instance entry point ${aws_instance.quest.public_ip}"
}

output "application_url" {
  description = "Quest app access"
  value = "Use this URL to acees Quest APP: ${aws_lb.quest.dns_name}"
}