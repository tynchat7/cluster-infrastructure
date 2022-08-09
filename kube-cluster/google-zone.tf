resource "google_dns_managed_zone" "fuchicorp" {
  name     = "${var.deployment_name}-zone"
  dns_name = "${var.google_domain_name}."
  project  = "${var.google_project_id}"
  
}
resource "google_dns_record_set" "mx" {
  name         = "${google_dns_managed_zone.fuchicorp.dns_name}"
  managed_zone =  "${google_dns_managed_zone.fuchicorp.name}"
  project      = "${var.google_project_id}"
  type         = "MX"
  ttl          = 300

  rrdatas = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com.",
  ]
}