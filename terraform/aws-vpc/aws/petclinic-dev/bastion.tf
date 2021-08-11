resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-bastion-sg"
  }
  
}

# ec2 

#key
resource "aws_key_pair" "petclinic" {
  key_name   = "petclinic-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDyLp3jhBU0R57MY6crzKOgzD8snU88pH867ZTQts1li2H28NbSYbCNU4qlxDmp9VvW34k46WhWxVUb29onXjjKL8vc/X0I1x7Fyb2WwjAdzHnK6189Dv2tKxRewxI2HIQV8xOWP/1Nh2w4DmB836MNlrsJERvAqhtHQEJV+NVOIQ2QPazirMG0fAwzYxyKhid3L8BIxO2g1vciUU3X/SbYPtdrCpmxPulM3POBQTwYuiWRQUAcXpAxHNGAU5wz60v7SAiTPhVfSOzgO2q70B6kQbb8ul0MQMvLhuDBwCXYiRVvxyUplTwasGWZgBCupa/J/PsjgJM5yb1dIVaxBPHzkgxHpG9oaFmmuiYJjtkDIEgXI0B8fLIMrZXqBbCQFoI69AdsNGrIWjKXra3Y/lYLGoX5AnvwrnNTzbY362S8FdH6gqneRMwUZVlU5+yDh5bFgn2CV/hR4Watzyuzcftm1923e0/VeuQyEbkWAxxFjQIIrSMTDp+YxZ/pIgE5qZ8= 91986@DESKTOP-33U62L5"
}

resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.type
  subnet_id = aws_subnet.pubsubnet[0].id
  key_name = aws_key_pair.petclinic.id 
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]


  tags = {
    Name = "${var.envname}-bastion"
  }
}
