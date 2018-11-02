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
	app_port 				= "${var.app_configuration["app.port"]}"
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

#module "fg" {
#outs: 
#	source = "./fg"

#	vpc_id				= "${var.vpc_id}"
	
#	app_configuration	= "${var.app_configuration}"
	
#	subnet_ids			= "${var.orange_subnet_ids}"
	
#	cloudwatch_prefix	= "${var.cloudwatch_prefix}"
#	region				= "${var.region}"
#}
