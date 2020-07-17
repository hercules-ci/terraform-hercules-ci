
locals {
  configs = concat(
    [abspath("${path.module}/configuration.nix")],
    var.use_prebuilt ? [abspath("${path.module}/hercules-ci-cache.nix")] : [],
    var.configs
    )
  nixpkgs_src = jsondecode(file("${path.module}/sources.json"))["nixpkgs"]["url"]
}

module "deploy_nixos" {
  source = "git::https://github.com/tweag/terraform-nixos.git//deploy_nixos?ref=4979e668444529438d42f5230a59d2388dd65f86"

  config = "{ pkgs, lib, ... }: { imports = [ (/. + ''${join("'') (/. + ''",compact(flatten(local.configs)))}'') ]; }"

  target_user = "root"
  target_host = var.target_host
  target_system = var.target_system
  build_on_target = var.build_on_target
  NIX_PATH = "nixpkgs=${local.nixpkgs_src}"
  extra_eval_args = var.extra_eval_args
  extra_build_args = var.extra_build_args

  triggers = var.triggers

  ssh_private_key_file = var.ssh_private_key_file
  ssh_agent = var.ssh_agent

  keys = {
    cluster_join_token = var.cluster_join_token
    binary_caches_json = var.binary_caches_json
  }
}
