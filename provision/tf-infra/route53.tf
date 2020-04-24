#Route53 zone for environment
resource "aws_route53_zone" "dev-labs" {
  name = var.ecs_cluster_domain
}

#Route53 records for api
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.dev-labs.zone_id
  name    = var.ecs_cluster_host
  type    = "A"
  ttl     = "60"
  records = [data.external.ecs-cluster-meta.result.ecs_container_instance_ip]
}
