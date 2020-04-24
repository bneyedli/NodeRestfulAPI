resource "aws_route53_zone" "dev-labs" {
  name = "dev.labs.bledsol.net"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.dev-labs.zone_id
  name    = "node-rest-api.dev.labs.bledsol.net"
  type    = "A"
  ttl     = "300"
  records = ["54.91.114.33"]
}
