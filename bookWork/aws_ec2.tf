resource "aws_key_pair" "ubuntu" {
    key_name = "ubuntu"
    public_key = file(var.key_path.public_key_path)
}

##EC2
resource "aws_instance" "ubuntu_instance" {
  ami                     = var.ami
  instance_type           = var.instance_type
  associate_public_ip_address = true
  disable_api_termination = false
  key_name                = aws_key_pair.ubuntu.key_name
  vpc_security_group_ids  = [aws_security_group.ubuntu.id]
  subnet_id               = aws_subnet.ubuntu_subnet.id
 
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }

  tags = {
    Name = "ubuntu"
  }
}
 
##EIP
resource "aws_eip" "ubuntu" {
  instance = aws_instance.ubuntu_instance.id
  vpc      = true
}


resource "null_resource" "provisioner" {

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.key_path.private_key_path)
      host        = aws_eip.ubuntu.public_ip
    }

    inline = [
      #dockerをインストールするコマンド
      "sudo apt-get -y update",
      "sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent gnupg2 software-properties-common python3 python3-pip",
      "sudo pip3 install docker-compose",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo apt-key fingerprint 0EBFCD88",
      "sudo add-apt-repository -y \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get -y update",
      "sudo apt-get -y install docker-ce docker-ce-cli containerd.io",
      #dockerコマンドをsudoなしで使用する。
      "sudo gpasswd -a ubuntu docker",
      #minikube
      "sudo apt-get -y install conntrack",
      "sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "sudo install minikube-linux-amd64 /usr/local/bin/minikube",
      "sudo minikube start --vm-driver=none",
      #所有者変更
      "sudo chown -R $USER $HOME/.kube $HOME/.minikube",
      #kubectlコマンドinstall
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "echo \"deb https://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "sudo apt-get install -y kubectl",
      #eksctlコマンドinstall
      "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\"",
      "sudo apt-get install -y unzip",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "pip3 install --upgrade --user awscli",
      "curl --silent --location \"https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz\" | tar xz -C /tmp",
      "sudo mv /tmp/eksctl /usr/local/bin"
      # next =>aws configure(add AWS Access Key ID and AWS Secret Access Key)
    ]
  }
}