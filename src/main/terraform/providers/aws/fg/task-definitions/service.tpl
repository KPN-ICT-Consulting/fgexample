[
	{
		"name": "wordpress",
		"image": "${image_backend}",
		"cpu": ${cpu_backend},
		"memory": ${memory_backend},
		"essential": true,
		"portMappings": [
			{
				"containerPort": 9000,
				"hostPort": ${port_backend}
			}
		],
		"mountPoints": [
            {
                "sourceVolume": "/tmp/demo",
                "containerPath": "/var/www/html"
            }
        ]
	},
	{
		"name": "nginx",
		"image": "${image_front}",
		"cpu": ${cpu_front},
		"memory": ${memory_front},
		"essential": true,
		"portMappings": [
			{
				"containerPort": 80,
				"hostPort": ${port_front}
			}
		],
		"mountPoints": [
            {
                "sourceVolume": "/tmp/demo",
                "containerPath": "/var/www/html"
            }
        ]
	}
]