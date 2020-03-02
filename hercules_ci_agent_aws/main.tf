
module "nixos" {
  source = "../hercules_ci_agent_nixos"
  target_host = "${aws_instance.machine.public_ip}"
  use_prebuilt = "${var.use_prebuilt}"
  configs = concat([abspath("${path.module}/configuration-aws.nix")], var.configs)
  cluster_join_token = "${var.cluster_join_token}"
  binary_caches_json = "${var.binary_caches_json}"
  triggers = {
    machine_id = "${aws_instance.machine.id}"
  }
}

module "nixos_image_1909" {
  source = "git::https://github.com/tweag/terraform-nixos.git//aws_image_nixos?ref=5df90bfe4b634a4abbe31bc99fb301d02c9f0c5d"
  release = "19.09"
}

resource "aws_security_group" "ssh_and_egress" {
  ingress {
    # SSH for deployment
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ] # TODO: restrict
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-${sha256(var.public_key)}"
  public_key = "${var.public_key}"
}

resource "aws_instance" "machine" {
  ami           = "${module.nixos_image_1909.ami}"
  instance_type = "${var.instance_type}"
  security_groups = [ "${aws_security_group.ssh_and_egress.name}" ]
  key_name = "${aws_key_pair.deployer.key_name}"
  
  root_block_device {
    volume_size = "${var.disk_size}" # GiB
  }
}

output "public_dns" {
  value = "${aws_instance.machine.public_dns}"
}
