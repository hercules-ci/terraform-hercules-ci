
locals {
  configs = concat(
    [abspath("${path.module}/configuration.nix")],
    var.use_prebuilt ? [abspath("${path.module}/hercules-ci-cache.nix")] : [],
    var.configs
    )
  nixpkgs_src = jsondecode(file("${path.module}/sources.json"))["nixpkgs"]["url"]
}

module "deploy_nixos" {
  source = "git::https://github.com/hercules-ci/terraform-nixos.git//deploy_nixos?ref=69ea6c828b7de27bb6f89e8d167c9656fd4dbc89"

  config = "{ pkgs, lib, ... }: { imports = [ (/. + ''${join("'') (/. + ''",compact(flatten(local.configs)))}'') ]; }"

  target_user = "root"
  target_host = "${var.target_host}"
  build_on_target = true
  NIX_PATH = "nixpkgs=${local.nixpkgs_src}"

  triggers = "${var.triggers}"

  ssh_private_key_file = var.ssh_private_key_file
  ssh_agent = var.ssh_agent

  system = var.system

  keys = {
    cluster_join_token = "${var.cluster_join_token}"
    binary_caches_json = "${var.binary_caches_json}"
  }
}
