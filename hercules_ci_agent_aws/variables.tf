
variable "use_prebuilt" {
  type = "string"
  description = "Get agent binaries from the hercules-ci cache"
  default = true
}

variable "configs" {
  type = "list"
  description = "Extra NixOS configuration modules to import"
}

variable "cluster_join_token" {
  type = "string"
  description = "The cluster join token contents. See https://docs.hercules-ci.com/hercules-ci/reference/agent-config/#clusterJoinTokenPath"
}

variable "binary_caches_json" {
  type = "string"
  description = "The binary-caches.json contents. See https://docs.hercules-ci.com/hercules-ci/reference/agent-config/#binaryCachesPath"
}

variable "public_key" {
  type = "string"
  description = "An SSH public key. This corresponding private key must be loaded into the SSH agent, for example: `ssh-add ./id_rsa`."
}

variable "instance_type" {
  type = "string"
  description = "Amazon EC2 instance type"
  default = "t3.medium"
}

variable "disk_size" {
  type = "string"
  description = "Size of the filesystem in GiB"
  default = 100
}

variable "ssh_private_key_file" {
  description = "Path to private key used to connect to the target_host. Ignored if `-` or empty."
  default     = "-"
}

variable "ssh_agent" {
  description = "Whether to use an SSH agent"
  type        = bool
  default     = true
}

variable "ami" {
  description = "Amazon machine image. Default: official NixOS image determined via mapping."
  default     = null
}

variable "system" {
  type = string
  description = "Nix system string"
  default = "x86_64-linux"
}
