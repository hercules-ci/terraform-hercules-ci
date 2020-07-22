
variable "use_prebuilt" {
  type = string
  description = "Get agent binaries from the hercules-ci cache"
  default = true
}

variable "target_host" {
  type = string
  description = "NixOS host that will have an agent configuration applied to it. Must be reachable through SSH."
}

variable "target_system" {
  type = string
  description = "Nix system string"
  default = "x86_64-linux"
}

variable "build_on_target" {
  type        = string
  description = "Avoid building on the deployer. Must be true or false. Has no effect when deploying from an incompatible system. Unlike remote builders, this does not require the deploying user to be trusted by its host."
  default     = false
}

variable "configs" {
  type = list
  description = "Extra NixOS configuration modules to import"
}

variable "triggers" {
  type = map
  description = "Extra variables for Terraform to trigger deployment"
}

variable "cluster_join_token" {
  type = string
  description = "The cluster join token contents. See https://docs.hercules-ci.com/hercules-ci/reference/agent-config/#clusterJoinTokenPath"
}

variable "binary_caches_json" {
  type = string
  description = "The binary-caches.json contents. See https://docs.hercules-ci.com/hercules-ci/reference/agent-config/#binaryCachesPath"
}

variable "ssh_private_key_file" {
  type = string
  description = "Path to private key used to connect to the target_host. Ignored if `-` or empty."
  default     = "-"
}

variable "ssh_agent" {
  description = "Whether to use an SSH agent"
  type        = bool
  default     = true
}

variable "extra_eval_args" {
  description = "List of arguments to pass to the nix evaluation"
  type        = list(string)
  default     = []
}

variable "extra_build_args" {
  description = "List of arguments to pass to the nix builder"
  type        = list(string)
  default     = []
}

variable "NIX_PATH" {
  description = "NIX_PATH to use for evaluation. Example: \"nixpkgs=$${jsondecode(file(\"$${path.module}/../../nix/sources.json\"))[\"nixpkgs\"][\"url\"]}\""
  type        = string
}
