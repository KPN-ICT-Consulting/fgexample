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

resource "aws_db_instance" "db_instance" {
	identifier 							= "${var.db_configuration["db.name"]}"
	
	engine            					= "${var.db_configuration["db.engine"]}"
	engine_version    					= "${var.db_configuration["db.engine_version"]}"
	instance_class    					= "${var.db_configuration["db.instance_class"]}"
	allocated_storage 					= "${var.db_configuration["db.allocated_storage"]}"
	storage_type      					= "${var.db_configuration["db.storage_type"]}"
	storage_encrypted 					= "${var.db_configuration["db.storage_encrypted"]}"
	#kms_key_id        					= "${var.db_configuration["db.kms_key_id"]}"
	#license_model     					= "${var.db_configuration["db.license_model"]}"
	
	name                                = "${var.db_configuration["db.name"]}"
	username                            = "${var.db_configuration["db.username"]}"
	password                            = "${var.db_configuration["db.password"]}"
	port                                = "${var.db_configuration["db.port"]}"
	#iam_database_authentication_enabled = "${var.db_configuration["db.iam_database_authentication_enabled"]}"
	
	#replicate_source_db 				= "${var.db_configuration["db.replicate_source_db"]}"
	
	#snapshot_identifier 				= "${var.snapshot_identifier}"
	
	vpc_security_group_ids 				= ["${var.vpc_security_group_ids}"]
	db_subnet_group_name   				= "${var.db_configuration["db.subnet_group_name"]}"
	parameter_group_name   				= "${var.db_configuration["db.parameter_group_name"]}"
	option_group_name      				= "${var.db_configuration["db.option_group_name"]}"
	
	#availability_zone   				= "${var.availability_zone}"
	#multi_az            				= "${var.multi_az}"
	#iops                				= "${var.iops}"
	#publicly_accessible 				= "${var.publicly_accessible}"
	#monitoring_interval 				= "${var.monitoring_interval}"
	#monitoring_role_arn 				= "${coalesce(var.monitoring_role_arn, join("", aws_iam_role.enhanced_monitoring.*.arn))}"
	
	allow_major_version_upgrade 		= "${var.db_configuration["db.allow_major_version_upgrade"]}"
	auto_minor_version_upgrade  		= "${var.db_configuration["db.auto_minor_version_upgrade"]}"
	#apply_immediately           		= "${var.apply_immediately}"
	maintenance_window          		= "${var.db_configuration["db.maintenance_window"]}"
	#skip_final_snapshot         		= "${var.skip_final_snapshot}"
	copy_tags_to_snapshot       		= "${var.db_configuration["db.copy_tags_to_snapshot"]}"
	final_snapshot_identifier   		= "${format("%s-%s", var.db_configuration["db.name"], var.db_configuration["db.final_snapshot_identifier"])}"
	
	backup_retention_period 			= "${var.db_configuration["db.backup_retention_period"]}"
	backup_window           			= "${var.db_configuration["db.backup_window"]}"
	
	#character_set_name 					= "${var.character_set_name}"
	
	enabled_cloudwatch_logs_exports 	= ["${split(",", var.db_configuration["db.enabled_cloudwatch_logs_exports"])}"]
	
	deletion_protection 				= "${var.db_configuration["db.deletion_protection"]}"

  	tags {
		Name							= "${format("%s",var.db_configuration["db.name"])}"
		Envrionment						= "${var.isStaging ? "DEV" : "PROD"}"
	}
}

