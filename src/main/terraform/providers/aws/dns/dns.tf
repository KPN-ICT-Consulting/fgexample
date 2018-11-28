#
#
#
resource "aws_route53_record" "record" {
	zone_id 					= "${var.root_zone_id}"
	name						= "${var.domain}"
	type						= "A"
	
	weighted_routing_policy {
		weight 					= "${var.domain_weight}"
	}

	set_identifier				= "${var.domain_identifier}"
	
	alias {
		name					= "${var.cdn_domain_name}"
		zone_id					= "${var.cdn_domain_id}"
		evaluate_target_health	= false
	}
}

resource "aws_route53_record" "record_ipv6" {
	zone_id 					= "${var.root_zone_id}"
	name						= "${var.domain}"
	type						= "AAAA"
	
	weighted_routing_policy {
		weight 					= "${var.domain_weight}"
	}

	set_identifier				= "${var.domain_identifier}"
	
	alias {
		name					= "${var.cdn_domain_name}"
		zone_id					= "${var.cdn_domain_id}"
		evaluate_target_health	= false
	}
}
