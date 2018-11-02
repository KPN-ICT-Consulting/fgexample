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

# Traffic to the Database should only come from the ECS cluster
resource "aws_security_group" "sg_db" {
	name        			= "TF-WP-DB"
  	description 			= "Allow inbound access from the ECS cluster only"
  	vpc_id      			= "${var.vpc_id}"

  	ingress {
    	protocol        	= "tcp"
    	from_port       	= "${var.db_port}"
    	to_port         	= "${var.db_port}"
    	security_groups 	= ["${aws_security_group.sg_ecs_tasks.id}"]
  	}

  	egress {
    	protocol    		= "-1"
    	from_port   		= 0
    	to_port     		= 0
    	cidr_blocks 		= ["0.0.0.0/0"]
  	}
}
