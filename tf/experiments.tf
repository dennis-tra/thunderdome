module "tracing" {
  source = "./modules/experiment"
  name   = "tracing"

  ecs_cluster_id                                 = module.ecs.cluster_id
  vpc_subnets                                    = module.vpc.public_subnets
  security_groups                                = [aws_security_group.target.id]
  execution_role_arn                             = aws_iam_role.ecsTaskExecutionRole.arn
  log_group_name                                 = aws_cloudwatch_log_group.logs.name
  aws_service_discovery_private_dns_namespace_id = aws_service_discovery_private_dns_namespace.main.id

  grafana_secrets = [
    { name = "GRAFANA_USER", valueFrom = "${data.aws_secretsmanager_secret.grafana-push-secret.arn}:username::" },
    { name = "GRAFANA_PASS", valueFrom = "${data.aws_secretsmanager_secret.grafana-push-secret.arn}:password::" }
  ]

  shared_env = [
    { name = "IPFS_PROFILE", value = "server" },
    { name = "OTEL_TRACES_SAMPLER", value = "traceidratio" },
    { name = "OTEL_TRACES_EXPORTER", value = "otlp" },
    { name = "OTEL_EXPORTER_OTLP_INSECURE", value = "true" },
    { name = "OTEL_EXPORTER_OTLP_ENDPOINT", value = "http://localhost:4318" }
  ]

  targets = {
    "0" = {
      environment = [
        { name = "OTEL_TRACES_SAMPLER_ARG", value = "0" }
      ],
      image = "ipfs/kubo:v0.14.0"
    },
    "25" = {
      environment = [
        { name = "OTEL_TRACES_SAMPLER_ARG", value = "0.25" }
      ]
      image = "ipfs/kubo:v0.14.0"
    }
    "50" = {
      environment = [
        { name = "OTEL_TRACES_SAMPLER_ARG", value = "0.5" }
      ]
      image = "ipfs/kubo:v0.14.0"
    }
    "75" = {
      environment = [
        { name = "OTEL_TRACES_SAMPLER_ARG", value = "0.75" }
      ]
      image = "ipfs/kubo:v0.14.0"
    }
    "100" = {
      environment = [
        { name = "OTEL_TRACES_SAMPLER_ARG", value = "1" }
      ]
      image = "ipfs/kubo:v0.14.0"
    }
  }
}

module "peering" {
  source = "./modules/experiment"
  name   = "peering"

  ecs_cluster_id                                 = module.ecs.cluster_id
  vpc_subnets                                    = module.vpc.public_subnets
  security_groups                                = [aws_security_group.target.id]
  execution_role_arn                             = aws_iam_role.ecsTaskExecutionRole.arn
  log_group_name                                 = aws_cloudwatch_log_group.logs.name
  aws_service_discovery_private_dns_namespace_id = aws_service_discovery_private_dns_namespace.main.id
  grafana_secrets = [
    { name = "GRAFANA_USER", valueFrom = "${data.aws_secretsmanager_secret.grafana-push-secret.arn}:username::" },
    { name = "GRAFANA_PASS", valueFrom = "${data.aws_secretsmanager_secret.grafana-push-secret.arn}:password::" }
  ]

  shared_env = [
    { name = "IPFS_PROFILE", value = "server" },
  ]

  targets = {
    "with" = {
      image       = "147263665150.dkr.ecr.eu-west-1.amazonaws.com/thunderdome:peering-with"
      environment = []
    }
    "without" = {
      image       = "147263665150.dkr.ecr.eu-west-1.amazonaws.com/thunderdome:peering-without"
      environment = []
    }
  }
}

module "providerdelay" {
  source = "./modules/experiment"
  name   = "providerdelay"

  ecs_cluster_id                                 = module.ecs.cluster_id
  vpc_subnets                                    = module.vpc.public_subnets
  security_groups                                = [aws_security_group.target.id]
  execution_role_arn                             = aws_iam_role.ecsTaskExecutionRole.arn
  log_group_name                                 = aws_cloudwatch_log_group.logs.name
  aws_service_discovery_private_dns_namespace_id = aws_service_discovery_private_dns_namespace.main.id
  grafana_secrets = [
    { name = "GRAFANA_USER", valueFrom = "${data.aws_secretsmanager_secret.grafana-push-secret.arn}:username::" },
    { name = "GRAFANA_PASS", valueFrom = "${data.aws_secretsmanager_secret.grafana-push-secret.arn}:password::" }
  ]

  shared_env = [
    { name = "IPFS_PROFILE", value = "server" },
  ]

  targets = {
    "providerdelay-0ms" = {
      image       = "147263665150.dkr.ecr.eu-west-1.amazonaws.com/thunderdome:providerdelay-0ms"
      environment = []
    }
    "providerdelay-20ms" = {
      image       = "147263665150.dkr.ecr.eu-west-1.amazonaws.com/thunderdome:providerdelay-20ms"
      environment = []
    }
    "providerdelay-50ms" = {
      image       = "147263665150.dkr.ecr.eu-west-1.amazonaws.com/thunderdome:providerdelay-50ms"
      environment = []
    }
    "providerdelay-100ms" = {
      image       = "147263665150.dkr.ecr.eu-west-1.amazonaws.com/thunderdome:providerdelay-100ms"
      environment = []
    }
    "providerdelay-200ms" = {
      image       = "147263665150.dkr.ecr.eu-west-1.amazonaws.com/thunderdome:providerdelay-200ms"
      environment = []
    }
    "providerdelay-500ms" = {
      image       = "147263665150.dkr.ecr.eu-west-1.amazonaws.com/thunderdome:providerdelay-500ms"
      environment = []
    }
    "providerdelay-1000ms" = {
      image       = "147263665150.dkr.ecr.eu-west-1.amazonaws.com/thunderdome:providerdelay-1000ms"
      environment = []
    }
  }
}



resource "aws_security_group" "target" {
  name   = "target"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "target_allow_egress" {
  security_group_id = aws_security_group.target.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "target_allow_ipfs" {
  security_group_id = aws_security_group.target.id
  type              = "ingress"
  from_port         = 4001
  to_port           = 4001
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "target_allow_ipfs_udp" {
  security_group_id = aws_security_group.target.id
  type              = "ingress"
  from_port         = 4001
  to_port           = 4001
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "target_allow_gateway" {
  security_group_id        = aws_security_group.target.id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.dealgood.id
}
