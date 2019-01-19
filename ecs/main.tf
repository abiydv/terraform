provider "aws" {
  alias	                  = "${var.environment}"
  profile                 = "${var.environment}"
  shared_credentials_file = "$HOME/.aws/credentials"
  region                  = "${var.aws_region}"
}

data "aws_subnet_ids" "public" {
  provider = "aws.${var.environment}"
  vpc_id   = "${var.vpc_id["${var.environment}"]}"
  tags = {
    Tier = "Public"           # Make sure the subnets you want to use with Loadbalancer are tagged with "Tier:Public"
  }
}

data "aws_subnet_ids" "private" {
  provider = "aws.${var.environment}"
  vpc_id   = "${var.vpc_id["${var.environment}"]}"
  tags = {
    Tier = "Private"           # Make sure the subnets you want to use with Fargate are tagged with "Tier:Private"
  }
}

### LB SECURITY GROUP AND RULES START ###
resource "aws_security_group" "lb_sg" {
  provider       = "aws.${var.environment}"
  name           = "${var.environment}_lb_sg"
  description    = "Controls access to the ${var.environment} ALB"
  vpc_id         = "${var.vpc_id["${var.environment}"]}"
  tags = {
    Name         =  "${var.environment}_lb_sg"
    Environment  =  "${var.environment}"
  }
}

resource "aws_security_group_rule" "lb_sg_ingress" {
  provider          = "aws.${var.environment}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.lb_sg.id}"
}

resource "aws_security_group_rule" "lb_sg_egress" {
  provider          = "aws.${var.environment}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.lb_sg.id}"
} ### LB SECURITY GROUP AND RULES END ###

### ECS SECURITY GROUP AND RULES START ###
resource "aws_security_group" "ecs_sg" {
  provider        = "aws.${var.environment}"
  name            = "${var.environment}_ecs_sg"
  description     = "Controls access to ${var.environment} ECS"
  vpc_id          = "${var.vpc_id["${var.environment}"]}"
  tags = {
    Name          =  "${var.environment}_ecs_sg"
    Environment   =  "${var.environment}"
  }
}

resource "aws_security_group_rule" "ecs_sg_ingress" {
  provider                 = "aws.${var.environment}"
  type                     = "ingress"
  from_port                = "${var.app_port}"
  to_port                  = "${var.app_port}"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.ecs_sg.id}"
  source_security_group_id = "${aws_security_group.lb_sg.id}"
}

resource "aws_security_group_rule" "ecs_sg_egress" {
  provider           = "aws.${var.environment}"
  type               = "egress"
  from_port          = 0
  to_port            = 0
  protocol           = "-1"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = "${aws_security_group.ecs_sg.id}"
} ### ECS SECURITY GROUP AND RULES END ###

### LB TARGET GROUP LISTENER START ###
resource "aws_alb" "lb" {
  provider            = "aws.${var.environment}"
  name                = "${var.environment}-lb"
  internal 		        = false
  load_balancer_type  = "application"
  subnets             = ["${data.aws_subnet_ids.public.ids}"]
  security_groups     = ["${aws_security_group.lb_sg.id}"]
  tags = {
  	Environment  =  "${var.environment}"
  }
}

resource "aws_alb_target_group" "lb_tg" {
  provider             = "aws.${var.environment}"
  name                 = "${var.environment}-lb-tg"
  port                 = "${var.app_port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id["${var.environment}"]}"
  target_type          = "ip"
  deregistration_delay = 60
  health_check {
    healthy_threshold   = "3"
    interval            = "15"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = "${var.health_check_path}"
    unhealthy_threshold = "2"
  }
  tags = {
  	Environment  =  "${var.environment}"
  }
}

resource "aws_alb_listener" "lb_listen" {
  provider          = "aws.${var.environment}"
  load_balancer_arn = "${aws_alb.lb.id}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:${var.aws_region}:${var.aws_account_id["${var.environment}"]}:certificate/${var.lb_cert_name}"
  default_action {
    target_group_arn = "${aws_alb_target_group.lb_tg.id}"
    type             = "forward"
  }
} ### LB TARGET GROUP LISTENER END ###

### ECS CLUSTER START ###
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  provider      = "aws.${var.environment}"
  name          = "/ecs/${var.environment}-app"
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_ecs_cluster" "app_cluster" {
  provider   = "aws.${var.environment}"
  name       = "${var.environment}-app-cluster"
  depends_on = ["aws_cloudwatch_log_group.ecs_log_group"]
}

data "template_file" "td_template" {
  template = "${file("${path.module}/templates/app-td.json.tpl")}"

  vars {
    app_image            = "${var.app_image}"
    aws_region           = "${var.aws_region}"
    app_port             = "${var.app_port}"
    app_env              = "${var.environment}"
    container_env_value  = "${var.container_env_value}" # Use this to pass any runtime value to your container
                                                        # It allows to keep the docker image same across environments 
                                                        # but also change certain values as per environment at runtime
  }
}

resource "aws_ecs_task_definition" "app_td" {
  provider                 = "aws.${var.environment}"
  family                   = "${var.environment}_app"
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id["${var.environment}"]}:role/ecsTaskExecutionRole"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  container_definitions    = "${data.template_file.td_template.rendered}"
}

resource "aws_ecs_service" "app_service" {
  provider            = "aws.${var.environment}"
  name                = "${var.environment}_app_service"
  cluster             = "${aws_ecs_cluster.app_cluster.id}"
  task_definition     = "${aws_ecs_task_definition.app_td.arn}"
  desired_count       = "${var.app_count}"
  launch_type         = "FARGATE"
  network_configuration {
    security_groups   = ["${aws_security_group.ecs_sg.id}"]
    subnets           = ["${data.aws_subnet_ids.private.ids}"]
    assign_public_ip  = false
  }
  load_balancer {
    target_group_arn  = "${aws_alb_target_group.lb_tg.id}"
    container_name    = "app_container"
    container_port    = "${var.app_port}"
  }
  health_check_grace_period_seconds  =  600   # Delay this suitably to make sure the application comes up and ALB marks the 
                                              # container healthy. 
  depends_on          = ["aws_alb_listener.lb_listen"]
} ### ECS CLUSTER END ###

### ECS AUTOSCALING START ###
resource "aws_appautoscaling_target" "app_scale_target" {
  provider           = "aws.${var.environment}"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.app_cluster.name}/${aws_ecs_service.app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = "${var.ecs_as_max_containers}"
  min_capacity       = "${var.ecs_as_min_containers}"
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  provider            = "aws.${var.environment}"
  alarm_name          = "${var.environment}_app_CPU_High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.ecs_as_cpu_high_threshold_per}"
  alarm_actions       = ["${aws_appautoscaling_policy.app_up.arn}"]
  dimensions {
    ClusterName   = "${aws_ecs_cluster.app_cluster.name}"
    ServiceName   = "${aws_ecs_service.app_service.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_low" {
  provider            = "aws.${var.environment}"
  alarm_name          = "${var.environment}_app_CPU_Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.ecs_as_cpu_low_threshold_per}"
  alarm_actions       = ["${aws_appautoscaling_policy.app_down.arn}"]
  dimensions {
    ClusterName    = "${aws_ecs_cluster.app_cluster.name}"
    ServiceName    = "${aws_ecs_service.app_service.name}"
  }
}

resource "aws_appautoscaling_policy" "app_up" {
  provider           = "aws.${var.environment}"
  name               = "app-scale-up"
  service_namespace  = "${aws_appautoscaling_target.app_scale_target.service_namespace}"
  resource_id        = "${aws_appautoscaling_target.app_scale_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.app_scale_target.scalable_dimension}"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
} 

resource "aws_appautoscaling_policy" "app_down" {
  provider           = "aws.${var.environment}"
  name               = "app-scale-down"
  service_namespace  = "${aws_appautoscaling_target.app_scale_target.service_namespace}"
  resource_id        = "${aws_appautoscaling_target.app_scale_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.app_scale_target.scalable_dimension}"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"
    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
} ### ECS AUTOSCALING END ###

### ROUTE53 RECORD START ###
data "aws_route53_zone" "default" {
  provider = "aws.${var.environment}"
  name     = "${var.hosted_zone["${var.environment}"]}"
}

resource "aws_route53_record" "default" {
  provider = "aws.${var.environment}"
  zone_id  = "${data.aws_route53_zone.default.zone_id}"
  name     = "${var.endpoint}.${var.hosted_zone["${var.environment}"]}"
  type     = "A"
  alias {
    name                   = "${aws_alb.lb.dns_name}"
    zone_id                = "${aws_alb.lb.zone_id}"
    evaluate_target_health = false
  }
} ### ROUTE53 RECORD END ###
