variable "yaw_public_key" {
  type = string
}
variable "postgres_user" {
  type      = string
  sensitive = true
}
variable "postgres_password" {
  type      = string
  sensitive = true
}
# variable "github_token" {
#   type = string
# }
# variable "dockerhub_username" {
#   type = string
# }
# variable "dockerhub_password" {
#   type = string
# }
