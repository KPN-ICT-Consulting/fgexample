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

variable "staging" {
	description = "set to true if the Staging environment should be created. For Production set to false."
	# Set thru commandline
}
#variable "branch_based_region" {
#	description = "The region used related to the branch. Fx development=eu-west1 or master=eu-west-2"
#	type = "string"
#	default = BRANCH_BASED_REGION
#}
variable "site" {
	description = "The configuration for the site"
	type = "map"
	default = {
		domain						= "fg-testing.kpn-ictc-mapps.com"
		domain_weight				= 10
		domain_identifier			= "Staging"
		
		site_originId				= "fg-website-test.kpn-ictc-mapps.com"
		site_name					= "fg-website-test.kpn-ictc-mapps.com"
		site_root_object			= "index.php"
		site_error_object			= "error.php"
		site_name_tag				= "FG WP example"
		site_comment				= "RTFM"
		site_aliases				= "fg-testing.kpn-ictc-mapps.com"
		price_class					= "PriceClass_100"
		georestriction				= "whitelist"
		geolist						= "NL,BE"
	}
}
variable "app_configuration" {
	description = "The configuration of the application to deploy to fargate"
	type = "map"
	default = {
		app.backend.image			= "kpnictc/wordpress-demo:dev"
		app.backend.port			= 9000
		app.front.image				= "kpnictc/nginx-demo:dev"
		app.front.port				= 80
		app.count 					= "2"
		fargate.cpu					= 256 #Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)
		fargate.memory				= 512 #Fargate instance memory to provision (in MiB)
	}
}
variable "db_configuration" {
	description = "The configuration of the application database to deploy to RDS"
	type = "map"
	default = {
		db.name                 			= "wp"
		db.engine							= "mysql"
		db.engine_version       			= "5.7"
		db.port								= 3306
		db.allow_major_version_upgrade		= true
		db.auto_minor_version_upgrade		= true
		db.enabled_cloudwatch_logs_exports	= "audit,error,general,slowquery"
		db.maintenance_window				= "Mon:00:00-Mon:03:00"
		db.backup_retention_period			= 7
		db.backup_window					= "03:00-06:00"
		db.copy_tags_to_snapshot			= true
		db.final_snapshot_identifier		= "FINAL"
		db.deletion_protection				= false
		db.storage_type         			= "gp2"
		db.allocated_storage				= 10
		db.instance_class       			= "db.t2.small"
		db.storage_encrypted				= true
		db.option_group_name				= "wordpress-db-options"
		db.option_group_description 		= "TF managed db option group for Wordpress DB"
		db.parameter_group_name				= "wordpress-db-params"
		db.parameter_group_description		= "TF managed db param group for Wordpress DB"
		db.subnet_group_name				= "wordpress-db-subnet-group"
		#TODO set below params through commandline vars
		db.username             			= "foo" 
		db.password             			= "foobarbaz"
	}
}
variable "db_options" {
	description = "The database options"
	type = "list"
	default = [
	    {
	      	option_name = "Timezone"
	
	      	option_settings = [
		        {
		          	name  = "TIME_ZONE"
		          	value = "UTC"
		    	}
		    ]
	    },
	    {
      		option_name = "MARIADB_AUDIT_PLUGIN"

      		option_settings = [
	        	{
	          		name  = "SERVER_AUDIT_EVENTS"
	          		value = "CONNECT"
	        	},
	        	{
	          		name  = "SERVER_AUDIT_FILE_ROTATIONS"
	          		value = "36"
	        	}
      		]
    	}
  	]
}
variable "db_parameters" {
	description = "The database parameters"
	type = "list"
	default = [
	    {
	      	name  = "character_set_server"
    		value = "utf8"
	    },
	    {
      		name  = "character_set_client"
    		value = "utf8"
    	}
  	]
}
# ==== Cloudwatch variables ====
variable "cloudwatch_prefix" {
	description = "Prefix for Cloudwatch to separate log groups"
	default     = "" # To avoid cloudwatch collision or if you don't want to merge all logs to one log group specify a prefix
}
