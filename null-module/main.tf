variable "num" {
  type = string
}

resource "null_resource" "null" {
  triggers = {
    num = "${var.num}"
  }
}

