output "creation_date" {
  description = "The date the user pool was created"
  value       = aws_cognito_user_pool.user_pool.creation_date
}

output "last_modified_date" {
  description = "The date the user pool was last modified"
  value       = aws_cognito_user_pool.user_pool.last_modified_date
}
#
# aws_cognito_user_pool_client
#
# output "client_ids" {
#   description = "The ids of the user pool clients"
#   value       = aws_cognito_user_pool_client.pmp_client.*.id
# }

# output "client_secrets" {
#   description = " The client secrets of the user pool clients"
#   value       = aws_cognito_user_pool_client.pmp_client.*.client_secret
# }

# #
# # aws_cognito_resource_servers
# #
