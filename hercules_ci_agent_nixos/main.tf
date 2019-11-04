
locals {
  configs = [
    "${path.module}/configuration.nix",
    "${var.use_prebuilt ? "${path.module}/hercules-ci-cache.nix" : "" }",
    "${var.configs}"
  ]
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
    "{ src }: let sources = import (src + \"/nix/sources.nix\"); in { nixpkgs = builtins.readFile (builtins.toFile \"nixpkgs\" sources.\"nixpkgs\".outPath); }",
    "--arg",
    "src",
    "~/h/hercules-ci-agent",
  ]
}

module "deploy_nixos" {
  source = "git::https://github.com/tweag/terraform-nixos.git//deploy_nixos?ref=d61e2a193620df13af5930be16f5b1f572f95ffa"

  config = "{ pkgs, lib, ... }: { imports = [ (/. + ''${join("'') (/. + ''",compact(flatten(local.configs)))}'') ]; }"

  target_user = "root"
  target_host = "${var.target_host}"
  NIX_PATH = "nixpkgs=${data.external.nixpkgs_src.result["nixpkgs"]}"

  triggers = "${var.triggers}"

  keys = {
    cluster_join_token = "${var.cluster_join_token}"
    binary_caches_json = "${var.binary_caches_json}"
  }
}
