#create databse
resource "aws_db_subnet_group" "dbsubnet" {
  name       = "dbsubnet"
  subnet_ids = [var.priv1 , var.priv2]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "oceanic" {
  allocated_storage    = 10
  db_name              = "oceanic"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  username             = var.username
  password             = var.password
  identifier           = var.identifier
  vpc_security_group_ids = [var.secgrp]
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.dbsubnet.id
}
