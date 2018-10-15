provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

data "terraform_remote_state" "tfstate" {
  backend = "s3"

  config {
    bucket = "tf-perf-us-east-1"
    key = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_security_group" "sg_jmeter" {
  name = "sg_jmeter"
  description = "Allows all traffic"

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "jmeter"
  public_key = "${file("jmeter.pub")}"

}

data "template_file" "slave_data" {
  template = "${file("templates/slave.tpl")}"
}

resource "aws_instance" "jmeter_slave1" {
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.sg_jmeter.name}"]
  ami = "${lookup(var.amis, var.region)}"
  key_name = "jmeter"
  user_data = "${data.template_file.slave_data.rendered}"
  tags {
    "Name" = "${var.run_name}"
  }
  connection {
      user = "ubuntu"
      private_key = "${file("jmeter.prv")}"
  }

  provisioner "remote-exec" {
      connection {
        user = "ubuntu"
        host = "${aws_instance.jmeter_slave1.public_ip}"
        timeout = "10m"
        private_key = "${file("jmeter.prv")}"
      }
      inline = [
        "while [ ! -f started ]; do sleep 10; echo \"Waiting for startup.\"; done",
        "echo JMeter Server Ready."
      ]
    }
}