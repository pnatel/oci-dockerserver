output "SSH" {
  value = "ssh -i ~/scripts/SSH/oci_vm ubuntu@${oci_core_instance.oci-instance.public_ip}"
}
# output "Monitor_installation_progress" {
#   value = "tail -F /var/log/cloudoffice.log"
# }
# output "WebUI" {
#   value = "${var.enable_dns != 0 && var.web_port == "443" ? "https://${var.dns_domain}/nc/" : ""}${var.enable_dns != 0 && var.web_port != "443" ? "https://${var.dns_domain}:${var.web_port}/nc/" : ""}${var.enable_dns == 0 && var.web_port == "443" ? "https://${oci_core_instance.oci-instance.public_ip}/" : ""}${var.enable_dns == 0 && var.web_port != "443" ? "https://${oci_core_instance.oci-instance.public_ip}:${var.web_port}/" : ""}"
# }
# output "Admin_creds" {
#   value = "USER: ${var.NC_ADMIN_USER} PWD: sudo docker exec cloudoffice_nextcloud env | grep NEXTCLOUD_ADMIN_PASSWORD"
# }

# output "Remove_containers_b4_upgrade" {
#   value = "sudo docker rm -f cloudoffice_database cloudoffice_nextcloud cloudoffice_webproxy cloudoffice_onlyoffice cloudoffice_redis"
# }
# output "Re-apply_Ansible_playbook" {
#   value = "sudo systemctl restart cloudoffice-ansible-state.service"
# }

# output "destroying" {
#   value = <<OUTPUT
# If destroying a project, delete all bucket objects before running terraform destroy.
# WARNING: THESE BUCKETS HOLD NEXTCLOUD+DB BACKUPS.
#  e.g:
# "oci os object bulk-delete-versions -bn ${oci_objectstorage_bucket.oci-bucket.name} -ns ${data.oci_objectstorage_namespace.oci-bucket-namespace.namespace}"
# "oci os object bulk-delete-versions -bn ${oci_objectstorage_bucket.oci-bucket.name}-data -ns ${data.oci_objectstorage_namespace.oci-bucket-namespace.namespace}"
# # Delete the files in the bucket, and then delete the bucket
# "aws --endpoint-url=https://${var.OBJECTSTORE_S3_HOSTNAME} --profile <PROFILE_NAME> S3 rm s3://${var.prefix}-oci-data-${random_string.oci-random.result}/ --recursive --include '*'" 
# "aws --endpoint-url=https://${var.OBJECTSTORE_S3_HOSTNAME} --profile <PROFILE_NAME> s3api delete-bucket --bucket ${var.prefix}-oci-data-${random_string.oci-random.result}"
# OUTPUT
# }