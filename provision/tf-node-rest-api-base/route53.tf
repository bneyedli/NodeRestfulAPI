#Route53 records for api
resource "aws_route53_record" "www" {
  zone_id = var.route53_zone_id
  name    = var.ecs_cluster_host
  type    = "A"
  ttl     = "60"
  records = [data.external.ecs-cluster-meta.result.ecs_container_instance_ip]
}
