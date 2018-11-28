#
#
#
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
	comment = "Cloudfront for ${var.site_name}"
}

resource "aws_cloudfront_distribution" "cdn" {
	origin {
		domain_name 					= "${var.alb_dns_name}"
		origin_id						= "${var.site_originId}"
		
		custom_origin_config {
			http_port    				= 8080
			https_port               	= 8443
			origin_protocol_policy   	= "http-only"
			origin_ssl_protocols     	= ["TLSv1", "TLSv1.1", "TLSv1.2"]
			origin_keepalive_timeout 	= 60
			origin_read_timeout 		= 60

			#origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
		}
	}

	enabled				= true
	is_ipv6_enabled		= true
	comment				= "${var.site_comment}"
	default_root_object	= "${var.site_root_object}"
	
	aliases				= "${split(",", var.site_aliases)}"
	
	default_cache_behavior {
		allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
		cached_methods   = ["GET", "HEAD"]
		target_origin_id = "${var.site_originId}"
		
		forwarded_values {
			query_string = false
			
			cookies {
				forward = "none"
			}
		}
	
		viewer_protocol_policy = "redirect-to-https"
		min_ttl                = 0
		default_ttl            = 3600
		max_ttl                = 86400
		compress				= true
  	}
  
  	# Cache behavior with precedence 0
  	ordered_cache_behavior {
  		path_pattern     = "/content/immutable/*"
  		allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  		cached_methods   = ["GET", "HEAD", "OPTIONS"]
  		target_origin_id = "${var.site_originId}"
  		
  		forwarded_values {
  			query_string = false
  			headers      = ["Origin"]
  			
  			cookies {
  				forward = "none"
  			}
  		}
  	
  		min_ttl                = 0
  		default_ttl            = 86400
  		max_ttl                = 31536000
  		compress               = true
  		viewer_protocol_policy = "redirect-to-https"
  	}
  
  	# Cache behavior with precedence 1
  	ordered_cache_behavior {
  		path_pattern     = "/content/*"
    	allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    	cached_methods   = ["GET", "HEAD"]
    	target_origin_id = "${var.site_originId}"

    	forwarded_values {
      		query_string = false

      		cookies {
        		forward = "none"
      		}
    	}

    	min_ttl                = 0
    	default_ttl            = 3600
    	max_ttl                = 86400
    	compress               = true
    	viewer_protocol_policy = "redirect-to-https"
  	}

	price_class = "${var.price_class}"
	
	restrictions {
    	geo_restriction {
      		restriction_type = "${var.geo_restriction}"
      		locations        = "${split(",", var.geo_list)}"
    	}
  	}
  
  	tags {
  		Environment = "${var.domain_identifier}"
  	}
  
  	viewer_certificate {
  		cloudfront_default_certificate = true
  	}  
}
