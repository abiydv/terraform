[{
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "/ecs/${app_env}-app",
      "awslogs-region": "${aws_region}",
      "awslogs-stream-prefix": "ecs"
    }
  },
  "portMappings": [{
    "hostPort": ${app_port},
    "protocol": "tcp",
    "containerPort": ${app_port}
  }],
  "cpu": 0,
  "image": "${app_image}",
  "essential": true,
  "name": "app_container",
  "environment": [
    {
      "Name": "container_env_value",
      "Value": "${container_env_value}"
    }]
}]
