resource "aws_instance" "web_server" {
  ami = var.ami
  instance_type = var.instance
  key_name = "royal_key"
  security_groups = ["royal_new_sg"]
  tags = {
    Name = var.tag
    Env = "Dev"
  }
}