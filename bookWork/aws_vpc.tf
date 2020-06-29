## VPCの設定
resource "aws_vpc" "ubuntu_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
 
  tags = {
    Name = "ubuntu_vpc"
  }
}
 
##サブネットの作成
resource "aws_subnet" "ubuntu_subnet" {
  vpc_id            = aws_vpc.ubuntu_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
 
  tags = {
    Name = "ubuntu_subnet"
  }
}

 
##ルートテーブルの追加(0.0.0.0/0)
resource "aws_route_table" "ubuntu_route" {
  vpc_id = aws_vpc.ubuntu_vpc.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ubuntu_GW.id
  }
}
 
##ルートテーブルの追加
resource "aws_route_table_association" "ubuntu_route_subnet" {
  subnet_id      = aws_subnet.ubuntu_subnet.id
  route_table_id = aws_route_table.ubuntu_route.id
}

 
##ゲートウェイの設定
resource "aws_internet_gateway" "ubuntu_GW" {
  vpc_id = aws_vpc.ubuntu_vpc.id
}