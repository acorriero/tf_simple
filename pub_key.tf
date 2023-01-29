resource "aws_key_pair" "ac_simple_public_key" {
  key_name   = "ac-simple-key"
  public_key = file(var.ac_simple_public_key)
}