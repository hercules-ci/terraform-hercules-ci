
locals {
  configs = concat(
    [abspath("${path.module}/configuration.nix")],
    var.use_prebuilt ? [abspath("${path.module}/hercules-ci-cache.nix")] : [],
    var.configs
    )
}

data "external" "nixpkgs_src" {
  program = [
    "/usr/bin/env",
    "NIX_PATH=",
    "nix-instantiate",
    "--eval",
    "--expr",
    "--json",
    "--read-write-mode",
    "--strict",
    "{ src }: let sources = import (src + \"/nix/sources.nix\"); in { nixpkgs = builtins.readFile (builtins.toFile \"nixpkgs\" sources.\"nixos-19.09\".outPath); }",
    "--arg",
    "src",
    "(import (${path.module} + ''/sources.nix'')).hercules-ci-agent",
  ]
}

module "deploy_nixos" {
  source = "git::https://github.com/hercules-ci/terraform-nixos.git//deploy_nixos?ref=552662291bf008d8c6f28e5d965787854844f00d"

  config = "{ pkgs, lib, ... }: { imports = [ (/. + ''${join("'') (/. + ''",compact(flatten(local.configs)))}'') ]; }"

  target_user = "root"
  target_host = "${var.target_host}"
  NIX_PATH = "nixpkgs=${data.external.nixpkgs_src.result["nixpkgs"]}"

  triggers = "${var.triggers}"

  ssh_private_key_file = var.ssh_private_key_file

  keys = {
    cluster_join_token = "${var.cluster_join_token}"
    binary_caches_json = "${var.binary_caches_json}"
  }
}
