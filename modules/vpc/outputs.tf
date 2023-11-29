output "public1" {
  value = aws_subnet.public1.id
}
output "public2" {
  value = aws_subnet.public2.id
}
output "public3" {
  value = aws_subnet.public3.id
}
output "public4" {
  value = aws_subnet.public4.id
}
output "private1" {
  value = aws_subnet.private1.id
}
output "private2" {
  value = aws_subnet.private2.id
}
output "Bastion" {
  value = aws_security_group.Bastion.id
}
output "Alb" {
  value = aws_security_group.Alb.id
}
output "Wlb" {
  value = aws_security_group.Wlb.id
}
output "Appserver" {
  value = aws_security_group.Appserver.id
}
output "Webserver" {
  value = aws_security_group.Webserver.id
}
output "Db-sg" {
  value = aws_security_group.DB-SG.id
}
output "aws_ssm_parameter" {
  value = data.aws_ssm_parameter.this.value
}
output "vpc_id" {
  value = aws_vpc.threetier.id
}
