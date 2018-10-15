output "slave_1_public" {
  value = "${aws_instance.jmeter_slave1.public_dns}"
}
