variable "ami" {
    default = "ami-0ac80df6eff0e70b5"
 }
 
variable "instance_type" {
    default = "t2.micro"
 }

variable "key_path" {
  default = {
    public_key_path = "/Users/junwatanabe/.ssh/pre-menta.pub"
    private_key_path = "/Users/junwatanabe/.ssh/pre-menta.pem" 
  }
}