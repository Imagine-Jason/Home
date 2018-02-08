server {
	listen *:443    ssl;
	server_name     kahla.app.aiursoft.com;
	ssl_certificate /home/anduin/Certs/Kahla.App/214495128710091.pem;
	ssl_certificate_key /home/anduin/Certs/Kahla.App/214495128710091.key;
	include	SSLOptions.conf;
	add_header Access-Control-Allow-Origin *;
	location / {
		root	/home/anduin/Published/Kahla.App;
	}
}

