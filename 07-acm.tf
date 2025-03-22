//tls_private_key is a hashicorp module you will have to initialize terraform again after using this module
//create a private key to encrypt the certificate
resource "tls_private_key" "midterms" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
//create the public cert using the private key
resource "tls_self_signed_cert" "midterms" {
  private_key_pem = tls_private_key.midterms.private_key_pem

  subject {
    common_name  = "spring.midterms.com"
    organization = "UMD"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
//import the certificate and private key to the acm
resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.midterms.private_key_pem
  certificate_body = tls_self_signed_cert.midterms.cert_pem
}