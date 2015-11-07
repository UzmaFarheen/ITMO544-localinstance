!/bin/bash

#load balancer creation
aws elb create-load-balancer --load-balancer-name ITMO-544-MP-loadbalancer --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --availability-zones us-east-1a us-east-1b

#load balancer registration
aws elb register-instances-with-load-balancer --load-balancer-name ITMO-544-MP-loadbalancer --instances *insert instances here*

#health check policy configuration
aws elb configure-health-check --load-balancer-name ITMO-544-MP-loadbalancer --health-check Target=HTTP:80/png,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3

#cookie-stickiness policy configuration
aws elb create-lb-cookie-stickiness-policy --load-balancer-name ITMO-544-MP-loadbalancer --policy-name ITMO-544-cookiepolicy --cookie-expiration-period 60

#cloud watch metrics creation
aws cloudwatch put-metric-alarm --alarm-name cloudwatch --alarm-description "Alarm when CPU exceeds 30 percent" --metric-name CPUUtilizing
--namespace AWS/EC2 --statistic Average --period 300 --threshold 30 --comparison-operator GreaterThanThreshold  --dimensions 
 Name=InstanceId,Value=i-12345678 --evaluation-periods 2 --alarm-actions arn:aws:sns:us-east-1:111122223333:MyTopic --unit Percent


#Autoscaling group creation
aws autoscaling create-auto-scaling-group --auto-scaling-group-name itmo-544-autoscaling --launch-configuration-name itmo544-launch-config --load-balancer-names ITMO-544-MP-loadbalancer  --health-check-type ELB --min-size 3 --max-size 6 --desired-capacity 3 --default-cooldown 600 --health-check-grace-period 120 --vpc-zone-identifier subnet-cccce295 

#AWS RDS instances creation
aws rds-create-db-instance ITMO544-MP1-DB --engine MySQL 

#read replica creation
aws rds-create-db-instance-read-replica ITMO544-MP1-DB-replica --source-db-instance-identifier-value ITMO544-MP1-DB
