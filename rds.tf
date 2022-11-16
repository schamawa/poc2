resource "random_password" "passwd" {
  length           = 8
  special          = true
}



resource "aws_secretsmanager_secret" "my-secret" {
   name = "my-secret2"
}



resource "aws_secretsmanager_secret_version" "my-s-version" {
  secret_id = aws_secretsmanager_secret.my-secret.id
  secret_string = <<EOF
   {
    "username": "admin",
    "password": "${random_password.passwd.result}"
   }
EOF
}




data "aws_secretsmanager_secret" "secret-store" {
  arn = aws_secretsmanager_secret.my-secret.arn
}



data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.secret-store.id
}




locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}

#######################################DB Instance######################################


resource "aws_db_subnet_group" "db-subnet2" {
  name       = "db-subnet2"
  subnet_ids = [aws_subnet.subnet_pvt1.id, aws_subnet.subnet_pvt2.id]



 tags = {
    Name = "DB subnet group"
  }
}



resource "aws_db_instance" "db-mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = local.db_creds.username
  password             = local.db_creds.password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet2.id
  vpc_security_group_ids = [aws_security_group.test_sg2.id]
  multi_az             = false
  tags = {
    "Name" = "my-db-sql"
  }
}
