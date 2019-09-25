{ sources ? import ./sources.nix
, extraOverlays ? []
}:

let
  overlay = 
    _: pkgs: {
      inherit (import sources.niv {}) niv;
      updater = pkgs.callPackage ./updater.nix {};
    };
in
import sources.nixpkgs {
  overlays = [
    overlay
  ] ++ extraOverlays;
  config = {};
}
