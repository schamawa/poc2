resource "aws_security_group" "test_sg" {
  name   = "test_sg"
  vpc_id = aws_vpc.test_vpc.id

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    security_groups = [aws_security_group.test_sg1.id]
  }

ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    security_groups = [aws_security_group.test_sg2.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test_sg"
  }

}

################ Security_Group2 ###############################################


resource "aws_security_group" "test_sg1" {
  name   = "test_sg1"
  vpc_id = aws_vpc.test_vpc.id


  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

     tags = {
    Name = "test_sg1"
  }

}

###############################Security_Group3########################################################

resource "aws_security_group" "test_sg2" {
  name   = "test_sg2"
  vpc_id = aws_vpc.test_vpc.id


  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

     tags = {
    Name = "test_sg2"
  }

}

