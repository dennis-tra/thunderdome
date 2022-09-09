variable "name" {
  type        = string
  description = ""
}

variable "ecs_cluster_id" {
  type = string
}

variable "vpc_subnets" {
  type = list(string)
}
variable "dealgood_security_groups" {
  type = list(string)
}

variable "execution_role_arn" {
  type = string
}

variable "shared_env" {
  type = list(map(string))
}

variable "targets" {}

variable "log_group_name" {}

variable "aws_service_discovery_private_dns_namespace_id" {}

variable "grafana_secrets" {
  default = []
}

variable "dealgood_tag" {
  default = "2022-09-09__1045"
}

variable "ssm_exec_policy_arn" {
}

variable "dealgood_task_role_arn" {
}

variable "dealgood_secrets" {
}

variable "efs_file_system_id" {
}

variable "grafana_agent_dealgood_config_url" {
}

variable "grafana_agent_target_config_url" {
}


