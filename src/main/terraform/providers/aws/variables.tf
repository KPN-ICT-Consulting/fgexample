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

variable "region" {
	description = "The region to run the TF scripts in"
}
variable "vpc_id" {
	description = "The VPC id"
}
variable "app_configuration" {
	description = "The configuration of the application to deploy to fargate"
	type = "map"
}
variable "db_configuration" {
	description = "The configuration of the application db to deploy to RDS"
	type = "map"
}
variable "db_options" {
	description = "The database options"
	type = "list"
}
variable "db_parameters" {
	description = "The database parameters"
	type = "list"
}
variable "red_subnet_ids" {
	description = ""
	type = "list"
}
variable "orange_subnet_ids" {
	description = ""
	type = "list"
}
variable "cloudwatch_prefix" {
	description = "Prefix for Cloudwatch to separate log groups"
}
variable "isStaging" {
	description = "set to true if the Staging environment should be created. For Production set to false."
}