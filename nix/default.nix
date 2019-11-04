{ sources ? import ./sources.nix
, extraOverlays ? []
}:

let
  overlay = 
    _: pkgs: {
      inherit (import sources.niv {}) niv;
      updater = pkgs.callPackage ./updater.nix {};
      terraform-nixpkgs = pkgs.terraform;
      terraform = pkgs.terraform_0_11;
    };
in
import sources.nixpkgs {
  overlays = [
    overlay
  ] ++ extraOverlays;
  config = {};
}
