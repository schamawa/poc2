resource "aws_instance" "test_ec2" {
  ami           = "ami-094bbd9e922dc515d" # ap-southeast-1a
  subnet_id     = aws_subnet.subnet_pvt1.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.test_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_custom_profile.id
  depends_on = [aws_iam_instance_profile.ec2_custom_profile]
  ebs_block_device {
               device_name = "/dev/sdb"
               volume_size = "1"
               }
  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
chkconfig httpd on
echo -e "o\nn\np\n1\n\n+750M\nt\n8e\nw" |fdisk /dev/sdb
pvcreate /dev/sdb1
vgcreate test_vg /dev/sdb1
lvcreate -n test_lv -L 700M test_vg
mkfs -t xfs /dev/test_vg/test_lv
echo "/dev/mapper/test_vg-test_lv   /test                       xfs     nodev,nofail        0 0" >> /etc/fstab
mkdir /test
mount /test
EC2_AVAIL_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo "<h1>Hello VF-Cloud World – running on $(hostname -f) in AZ $EC2_AVAIL_ZONE on port 80 </h1>" >> /test/index.html
ln -s /test/index.html /var/www/html/index.html
yum install -y amazon-cloudwatch-agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start
EOF



  tags = {
    Name = "test-ec2"
  }


}

##############################EC2 Instance2 ###############################################

resource "aws_instance" "test1_ec2" {
  ami           = "ami-094bbd9e922dc515d" # ap-southeast-1b
  subnet_id     = aws_subnet.subnet_pvt2.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.test_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_custom_profile.id
  depends_on = [aws_iam_instance_profile.ec2_custom_profile]
  ebs_block_device {
               device_name = "/dev/sdb"
               volume_size = "1"
               }
  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
chkconfig httpd on
echo -e "o\nn\np\n1\n\n+750M\nt\n8e\nw" |fdisk /dev/sdb
pvcreate /dev/sdb1
vgcreate test_vg /dev/sdb1
lvcreate -n test_lv -L 700M test_vg
mkfs -t xfs /dev/test_vg/test_lv
echo "/dev/mapper/test_vg-test_lv   /test                       xfs     nodev,nofail        0 0" >> /etc/fstab
mkdir /test
mount /test
EC2_AVAIL_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo "<h1>Hello VF-Cloud World – running on $(hostname -f) in AZ $EC2_AVAIL_ZONE on port 80 </h1>" >> /test/index.html
ln -s /test/index.html /var/www/html/index.html
yum install -y amazon-cloudwatch-agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start
EOF


  tags = {
    Name = "test1-ec2"
  }
}

