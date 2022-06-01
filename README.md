tf-ghidra-instance
===================

[Terraform](https://www.terraform.io/) scripts to setup a Ghidra server on AWS.


Install Steps
=============
- Clone this repository.
- Change directory to the cloned folder.
- Configure the `awscli` for your operating system by following this [guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) 
- Install Terraform following this [guide](https://terraform-docs.io/user-guide/installation/)
- Execute the following commands:
    * `cp secrets/secrets.tfvars.example secrets/secrets.tfvars`
    * edit `secrets.tfvars` replacing `region`,`access_list`, and `ghidra_users` with the required values
    * `terraform init -var-file=secrets/secrets.tfvars`
    * `terraform plan -var-file=secrets/secrets.tfvars` 
    * `terraform apply  -var-file=secrets/secrets.tfvars` to spinup server on AWS
    * `./genkeys.sh` to generate SSH keys for the newly created server in the `./keys` directory
    * `cat ./keys/instanceip` to view the IP address of your newly crated server.
    * `ssh -i keys/ghidraserver.pem ubuntu@[IP address from above]` to SSH to the server.



Server Destroy Steps
=====================

Replace lines 78-97 in main.tf then save.

```
resource "aws_instance" "ghidra" {

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  user_data                   = data.template_file.init.rendered
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  disable_api_termination     = false
  tags                        = var.tags

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      vpc_security_group_ids,
      ami
    ]
  }

}
```

- Execute the following commands
    * `terraform apply -var-file=secrets/secrets.tfvars` to apply your recent changes

- After the changes are applied run `terraform destroy -var-file=secrets/secrets.tfvars`
  to destroy all resources.