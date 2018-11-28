#/*
# * Copyright (c) 2018 KPN
# *
# * Permission is hereby granted, free of charge, to any person obtaining
# * a copy of this software and associated documentation files (the
# * "Software"), to deal in the Software without restriction, including
# * without limitation the rights to use, copy, modify, merge, publish,
# * distribute, sublicense, and/or sell copies of the Software, and to
# * permit persons to whom the Software is furnished to do so, subject to
# * the following conditions:
# *
# * The above copyright notice and this permission notice shall be
# * included in all copies or substantial portions of the Software.
#
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#*/

provider "aws" {
	#assume_role {
    #	role_arn     = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
    #	session_name = "SESSION_NAME"
    #	external_id  = "EXTERNAL_ID"
  	#}
	region 					= "${var.region}"
}

module "security" {
#outs:
#     module.security.sg_alb_id
#     module.security.sg_ecs_tasks_id
#     module.security.sg_db_id
	source = "./sg"
	
	vpc_id					= "${var.vpc_id}"
	db_port 				= "${var.db_configuration["db.port"]}"
	app_port 				= "${var.app_configuration["app.front.port"]}"
}

module "rds" {
	source = "./rds"
	
	db_configuration		= "${var.db_configuration}"
	db_options				= "${var.db_options}"
	db_parameters			= "${var.db_parameters}"
	
	subnet_ids				= "${var.orange_subnet_ids}"
	vpc_security_group_ids	= "${module.security.sg_db_id}"
	
	isStaging				= "${var.isStaging}"
}

module "fg" {
#outs: 
#   module.fg.alb_dns_name
	source = "./fg"

	vpc_id				= "${var.vpc_id}"
	
	app_configuration	= "${var.app_configuration}"
	
	subnet_ids			= "${var.orange_subnet_ids}" #maybe use red instead of orange
	alb_sg_id			= "${module.security.sg_alb_id}"
	ecs_sg_id			= "${module.security.sg_ecs_tasks_id}"
	
	cloudwatch_prefix	= "${var.cloudwatch_prefix}"
	region				= "${var.region}"
}

module "cdn" {
	source = "./cdn"
	
	alb_dns_name		= "${module.fg.alb_dns_name}"
	site_name			= "${var.site["site_name"]}"
	site_origin_id		= "${var.site["site_originId"]}"
	site_comment		= "${var.site["site_comment"]}"
	site_root_object	= "${var.site["site_root_object"]}"
	site_aliases		= "${var.site["site_aliases"]}"
	price_class			= "${var.site["price_class"]}"
	geo_restriction		= "${var.site["georestriction"]}"
	geo_list			= "${var.site["geolist"]}"
	domain_identifier	= "${var.site["domain_identifier"]}"
	
}


module "dns" {
	source = "./dns"
	
	domain				= "${var.site["domain"]}"
	domain_weight		= "${var.site["domain_weight"]}"
	domain_identifier	= "${var.site["domain_identifier"]}"
	cdn_domain_name		= "${module.cdn.cdn_domain}"
	cdn_domain_id		= "${module.cdn.cdn_hosted_zone_id}"
	root_zone_id		= "${var.root_zone_id}"
}
