#create our bastion host

#create launch template for our app server
resource "aws_launch_template" "app_template" {
  name_prefix            = "app_Server"
  image_id               = var.aws_ssm_parameter
  instance_type          = "t2.micro"
  key_name = "baston"
  vpc_security_group_ids = [var.appsg]
  user_data              = filebase64("modules/autoscaling/script.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app_server"
    }
  }
}
## launch template for our bastion host
resource "aws_launch_template" "bastion" {
  name_prefix            = "bastion"
  image_id               = var.aws_ssm_parameter
  instance_type          = "t2.micro"
  key_name = "baston"
  vpc_security_group_ids = [var.bastsg]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "bastion"
    }
  }
}
## launch template for our webserver
resource "aws_launch_template" "web_template" {
  name_prefix            = "Web_Server"
  image_id               = var.aws_ssm_parameter
  instance_type          = "t2.micro"
  key_name = "baston"
  vpc_security_group_ids = [var.websg]
  user_data              = filebase64("modules/autoscaling/web.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Web_server"
    }
  }
}


#create app autoscaling group
resource "aws_autoscaling_group" "asgtt" {
  name = "asgtt"
  vpc_zone_identifier = [var.pri1, var.pri2]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_group" "bhsgt" {
  name = "bhsgt"
  vpc_zone_identifier = [var.pub1, var.pub2]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  launch_template {
    id      = aws_launch_template.bastion.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_group" "webgt" {
  name = "webgt"
  vpc_zone_identifier = [var.pub3, var.pub4]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_attachment" "asg_atch" {
  autoscaling_group_name = aws_autoscaling_group.asgtt.id
  lb_target_group_arn =  var.alb_target_group_arn
}
resource "aws_autoscaling_attachment" "wsg_atch" {
  autoscaling_group_name = aws_autoscaling_group.webgt.id
  lb_target_group_arn =  var.alb_target_group_arn2
}





