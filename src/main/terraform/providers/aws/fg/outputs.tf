#
# outputs
#
output "alb_dns_name" {
	value = "${element(concat(aws_alb.alb.*.dns_name, list("")), 0)}"
}
