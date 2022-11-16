resource "aws_vpc" "test_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "vpc"
  }
}

##########Subnet ap-southeast-1a######################################

resource "aws_subnet" "subnet_pub1" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.10.3.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "subnet_pub1"
  }
}

resource "aws_subnet" "subnet_pvt1" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.10.5.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "subnet_pvt1"
  }
}

##########Subnet ap-southeast-1b######################################

resource "aws_subnet" "subnet_pub2" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.10.4.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "subnet_pub2"
  }
}

resource "aws_subnet" "subnet_pvt2" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.10.6.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "subnet_pvt2"
  }
}
################ IGW ################################################

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test_IGW"
  }
}


#################NAT GW1 #################################################
resource "aws_eip" "test1" {
  
  vpc      = true
}


resource "aws_nat_gateway" "Nat_GW1" {
  
  allocation_id = aws_eip.test1.id
  subnet_id     = aws_subnet.subnet_pub1.id
  depends_on = [aws_eip.test1]

  tags = {
    Name = "Nat_GW1"
  }
}


#####################NAT GW2 ############################################

resource "aws_eip" "test2" {
  
  vpc      = true
}


resource "aws_nat_gateway" "Nat_GW2" {
  
  allocation_id = aws_eip.test2.id
  subnet_id     = aws_subnet.subnet_pub2.id
  depends_on = [aws_eip.test2]

  tags = {
    Name = "Nat_GW2"
  }
}
###################### Route_Table1 ######################################

resource "aws_route_table" "test_rt1" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # All resources in public subnet are accessible from all internet.
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "Public-route1"
  }
}



resource "aws_route_table_association" "test_rta1" {
  route_table_id = aws_route_table.test_rt1.id
  subnet_id      = aws_subnet.subnet_pub1.id
}

#####################RT2######################################################
resource "aws_route_table" "test_rt2" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # All resources in private subnet are accessible from all internet.
    nat_gateway_id = aws_nat_gateway.Nat_GW1.id
  }

  tags = {
    Name = "private-route1"
  }
}



resource "aws_route_table_association" "test_rta2" {
  route_table_id = aws_route_table.test_rt2.id
  subnet_id      = aws_subnet.subnet_pvt1.id
}

###############################RT3#############################################

resource "aws_route_table" "test_rt3" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # All resources in public subnet are accessible from all internet.
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "Public-route2"
  }
}

resource "aws_route_table_association" "test_rta3" {
  route_table_id = aws_route_table.test_rt3.id
  subnet_id      = aws_subnet.subnet_pub2.id
}

################################RT4#############################################

resource "aws_route_table" "test_rt4" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # All resources in private subnet are accessible from all internet.
    nat_gateway_id = aws_nat_gateway.Nat_GW2.id
  }

  tags = {
    Name = "Private-route2"
  }
}

resource "aws_route_table_association" "test_rta4" {
  route_table_id = aws_route_table.test_rt4.id
  subnet_id      = aws_subnet.subnet_pvt2.id
}
