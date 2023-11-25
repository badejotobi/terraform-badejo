resource "aws_vpc" "twotier" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "twotier"
  }
}

#------------------------------------------------
###SUBNET CREATION
#Lets Create subnet
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.twotier.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "public1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.twotier.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name = "public2"
  }
}
resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.twotier.id
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "public3"
  }
}
resource "aws_subnet" "public4" {
  vpc_id     = aws_vpc.twotier.id
  cidr_block = "10.0.6.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name = "public4"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.twotier.id
  cidr_block = "10.0.3.0/24"

  availability_zone = "us-east-1a"
  tags = {
    Name = "private1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.twotier.id
  cidr_block = "10.0.4.0/24"

  availability_zone = "us-east-1b"
  tags = {
    Name = "private2"
  }
}

#---------------------------------------------------
#INTERNET GATEWAY
#lets create our internet gateway
resource "aws_internet_gateway" "igw"{
  vpc_id = aws_vpc.twotier.id
  tags = {
    Name = "IGW"
  }
}

###
#create our elastic internet ip
resource "aws_eip" "eip_nat" {
  domain = "vpc"
  tags = {
    Name = "eip"
  }
}
#lets create nat gateway
resource "aws_nat_gateway" "natgat" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "natgat"
  }
}
###

#------------------------------------------------------


#lets create our route table
resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.twotier.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    
  }
  tags = {
    Name = "TwotierPublic"
  }
}
resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.twotier.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgat.id
  }
  tags = {
    Name = "TwotierPrivate"
  }
}


#route association
resource "aws_route_table_association" "a" {
  subnet_id= aws_subnet.public1.id
  route_table_id = aws_route_table.publicroute.id

}
#route association
resource "aws_route_table_association" "b" {
  subnet_id= aws_subnet.public2.id
  route_table_id = aws_route_table.publicroute.id

}
resource "aws_route_table_association" "c" {
  subnet_id= aws_subnet.public3.id
  route_table_id = aws_route_table.publicroute.id

}
resource "aws_route_table_association" "d" {
  subnet_id= aws_subnet.public4.id
  route_table_id = aws_route_table.publicroute.id

}
resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.privateroute.id
}
resource "aws_route_table_association" "f" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.privateroute.id
}


#------------------------------------------------
#create security groups
resource "aws_security_group" "Bastion" {
  vpc_id = aws_vpc.twotier.id
  name   = join("_", ["sg", aws_vpc.twotier.id])
  description = "Our Bastion Host security group"
  dynamic "ingress" {
    for_each = var.rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Twotier-Sg"
  }
}

resource "aws_security_group" "Appserver" {
  vpc_id = aws_vpc.twotier.id
  name = join("_",["ap", aws_vpc.twotier.id])
  ingress {
    description      = "Allow SSH from our Bastion Host"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.Bastion.id]
  }
  ingress {
    description      = "Allow load balancer to route to internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.Alb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "App-Web-ServerSg"
  }
  
}

resource "aws_security_group" "Webserver" {
  vpc_id = aws_vpc.twotier.id
  name = join("_",["wb", aws_vpc.twotier.id])
  ingress {
    description      = "Allow SSH from our Bastion Host"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.Bastion.id]
  }
  ingress {
    description      = "Allow load balancer to route to internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.Wlb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-ServerSg"
  }
  
}


resource "aws_security_group" "Alb" {
  vpc_id = aws_vpc.twotier.id
  name = join("_",["alb", aws_vpc.twotier.id])
  ingress {
    description      = "Load balancer to route to the internett"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Alb-Sg"
  }
  
}
resource "aws_security_group" "Wlb" {
  vpc_id = aws_vpc.twotier.id
  name = join("_",["wlb", aws_vpc.twotier.id])
  ingress {
    description      = "Load balancer to route to the internett"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Wlb-Sg"
  }
  
}
resource "aws_security_group" "DB-SG" {
  vpc_id = aws_vpc.twotier.id
  name = join("_",["dbsg", aws_vpc.twotier.id])
  ingress {
    description      = "database security group"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = [aws_security_group.Appserver.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Db-Sg"
  }
  
}
data "aws_ssm_parameter" "this" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


