resource "aws_cloudwatch_metric_alarm" "cwalarm" {
  alarm_name                = "cwalarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  depends_on                = [aws_instance.test_ec2]

  dimensions = {
    InstanceId = aws_instance.test_ec2.id
  }
}

#####################################CW2#############################################

resource "aws_cloudwatch_metric_alarm" "cwalarm1" {
  alarm_name                = "cwalarm1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  depends_on                = [aws_instance.test1_ec2]

  dimensions = {
    InstanceId = aws_instance.test1_ec2.id
  }
}

##############################CW3#######################################

resource "aws_cloudwatch_metric_alarm" "mem-utilization" {
  alarm_name                = "memory-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "mem_used_percent"
  namespace                 = "CWAgent"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 memory utilization"
  #insufficient_data_actions = []
  depends_on                = [aws_instance.test_ec2]
  dimensions = {
    InstanceId   = aws_instance.test_ec2.id
    InstanceType = "t2.micro"
    ImageId      = "ami-094bbd9e922dc515d"
  }
}

######################################CW4####################################################

resource "aws_cloudwatch_metric_alarm" "mem-utilization1" {
  alarm_name                = "memory-utilization1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "mem_used_percent"
  namespace                 = "CWAgent"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 memory utilization"
  #insufficient_data_actions = []
  depends_on                = [aws_instance.test1_ec2]
  dimensions = {
    InstanceId   = aws_instance.test1_ec2.id
    InstanceType = "t2.micro"
    ImageId      = "ami-094bbd9e922dc515d"
  }
}
