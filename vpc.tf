#vpc
    #1.cidr_block 2.tag
#subnet
    #1.vpc_id 2.cidr_block 3.zone 4.auto-assign-map_pub_ip
#Internet GW
    #1.vpc_id 2.tags
#route_table
    #1.vpc_id 2.route - cidr,gw_id 3.tags


#vpc
    #1.cidr_block 2.tag

resource "aws_vpc" "terravpc" {
    cidr_block = var.block1
    tags = {
        Name = "Terra_vpc"
    }
}

#subnet
    #1.vpc id 2.cidr_block 3.zone 4.auto-assign-map_pub_ip

resource "aws_subnet" "pubsub1" {
    vpc_id = aws_vpc.terravpc.id
    cidr_block = var.block2
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "terra_subnet1"
    }
}

resource "aws_subnet" "pubsub2" {
    vpc_id = aws_vpc.terravpc.id
    cidr_block = var.block3
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "terra_subnet2"
    }
}

resource "aws_subnet" "privatesub1" {
    vpc_id = aws_vpc.terravpc.id
    cidr_block = var.block4
    availability_zone = "us-east-1a"
    tags = {
        Name = "terra_subnet3"
    }
}

#Internet GW
    #1.vpc_id 2.tags

resource "aws_internet_gateway" "terra_igw" {
    vpc_id=aws_vpc.terravpc.id
    tags = {
        Name ="Terra_IGW"
    }
  
}

#route_table
    #1.vpc_id 2.route - cidr,gw_id 3.tags

resource "aws_default_route_table" "terra_rt1" {
    default_route_table_id = aws_vpc.terravpc.default_route_table_id

    route{
        cidr_block = var.block5
        gateway_id = aws_internet_gateway.terra_igw.id
        }
    tags = {
      Name = "Default_rt"
    }
}

resource "aws_route_table_association" "routeassociate1" {
    route_table_id = aws_default_route_table.terra_rt1.id
    subnet_id = aws_subnet.pubsub1.id
}

resource "aws_route_table_association" "routeassociate2" {
    route_table_id = aws_default_route_table.terra_rt1.id
    subnet_id = aws_subnet.pubsub2.id
}
