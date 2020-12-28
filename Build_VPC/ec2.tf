# Create public instance
resource "aws_instance" "Web-instance" {
  ami = "ami-0be2609ba883822ec"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.prod-public-subnet.id
  security_groups = [ aws_security_group.WebDMZ.id ]
  key_name = "Hiep"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    service httpd start
    chkconfig httpd on
    cd /var/www/html
    echo "<html><h1>Build VPC - Public subnet </h1></html>"  >  index.html
    EOF
  tags = {
    "Name" = "Web-instace"
    "ENV" = "Production"
  }

}
# Create private instance
resource "aws_instance" "backend-instance" {
  ami = "ami-0be2609ba883822ec"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.prod-private-subnet.id
  security_groups = [ aws_security_group.Backend-server.id ]
  key_name = "Hiep"

  tags = {
    "Name" = "Backend-instace"
    "ENV" = "Production"
  }

}
