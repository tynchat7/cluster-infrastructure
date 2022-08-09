output "DNS Nameservers" {
	value = "${google_dns_managed_zone.fuchicorp.name_servers}"
}
