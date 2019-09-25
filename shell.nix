{ pkgs ? import ./nix {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.niv
    pkgs.jq
    pkgs.terraform
  ];
}