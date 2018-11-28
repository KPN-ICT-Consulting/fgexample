#
# outputs
#
output "cdn_domain" {
	value = "${element(concat(aws_cloudfront_distribution.cdn.*.domain_name, list("")), 0)}"
}
output "cdn_hosted_zone_id" {
	value = "${element(concat(aws_cloudfront_distribution.cdn.*.hosted_zone_id, list("")), 0)}"
}
