{ pkgs, lib, ... }:
let
  sources = import ./sources.nix;
in
{
  imports = [ (sources.hercules-ci-agent + "/module.nix") ];
  services.hercules-ci-agent.enable = true;

  systemd.services.install-secrets = {
    enable = true;
    before = [ "hercules-ci-agent.service" ];
    wantedBy = [ "hercules-ci-agent.service" ];
    script = ''
      install --directory \
              --owner hercules-ci-agent \
              --group nogroup \
              --mode 0700 \
              /var/lib/hercules-ci-agent/secrets \
              ;
      install --mode 0400 \
              --owner hercules-ci-agent \
              /var/keys/cluster_join_token \
              /var/lib/hercules-ci-agent/secrets/cluster-join-token.key \
              ;
      install --mode 0400 \
              --owner hercules-ci-agent \
              /var/keys/binary_caches_json \
              /var/lib/hercules-ci-agent/secrets/binary-caches.json \
              ;
    '';
    serviceConfig.Type = "oneshot";
  };

}