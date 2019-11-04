
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
    "(import (${path.module} + "/sources.nix")).hercules-ci-agent",
  ]
}

module "deploy_nixos" {
  source = "git::https://github.com/hercules-ci/terraform-nixos.git//deploy_nixos?ref=30792ace8a09fb55a523db5db6f15cfeaa168fec"

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
