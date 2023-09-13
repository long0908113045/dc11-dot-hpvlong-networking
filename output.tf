output "devops_vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.devops_vpc.id
}

output "devops_public_subnets" {
  value = [
    for instance in aws_subnet.devops_public_subnets :
    {
      id         = instance.id
      cidr_block = instance.cidr_block
    }
  ]
}

output "devops_private_subnets" {
  value = [
    for instance in aws_subnet.devops_private_subnets :
    {
      id         = instance.id
      cidr_block = instance.cidr_block
    }
  ]
}