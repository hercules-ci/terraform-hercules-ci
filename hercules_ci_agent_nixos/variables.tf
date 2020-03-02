
variable "use_prebuilt" {
  type = "string"
  description = "Get agent binaries from the hercules-ci cache"
  default = true
}

variable "target_host" {
  type = "string"
  description = "NixOS host that will have an agent configuration applied to it. Must be reachable through SSH."
}

variable "configs" {
  type = "list"
  description = "Extra NixOS configuration modules to import"
}

variable "triggers" {
  type = "map"
  description = "Extra variables for Terraform to trigger deployment"
}

variable "cluster_join_token" {
  type = "string"
  description = "The cluster join token contents. See https://docs.hercules-ci.com/hercules-ci/reference/agent-config/#clusterJoinTokenPath"
}

variable "binary_caches_json" {
  type = "string"
  description = "The binary-caches.json contents. See https://docs.hercules-ci.com/hercules-ci/reference/agent-config/#binaryCachesPath"
}

variable "ssh_private_key_file" {
  description = "Path to private key used to connect to the target_host. Ignored if `-` or empty."
  default     = "-"
}
