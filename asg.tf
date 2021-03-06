resource "aws_launch_configuration" "elb_launch_config13" {
  image_id      = var.Ami-id2
  instance_type = "t2.micro"
  security_groups = [aws_security_group.SG-proj13.id]

  user_data =<<-EOF
              #!/bin/bash
              yum -y install httpd
              echo "Hello, from Terraform" > /var/www/html/index.html
              service httpd start
              chkconfig httpd on
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_project13" {
  name                 = "autoscaling"
  launch_configuration = aws_launch_configuration.elb_launch_config13.id
  min_size             = 2
  max_size             = 5
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = 4
  force_delete = true
  vpc_zone_identifier = [aws_subnet.pubsub-13-1.id, aws_subnet.pubsub-13-1.id,aws_subnet.pubsub-13-3.id]
}

