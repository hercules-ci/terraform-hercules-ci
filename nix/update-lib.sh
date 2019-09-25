#!/bin/false

update-niv() {
  echo 1>&2 update: Updating sources.json ...
  niv update
  echo 1>&2 update: Completed sources.json update
}

# Update a terraform git ref parameter
update-tf-refs() {
  eval "$(nix-instantiate --eval --expr --show-trace "$(cat <<"EOE"
{ sourceNames, filesSh, ... }:
let
  lib = (import ./nix {}).lib;
  inherit (lib) concatMapStringsSep hasPrefix;
  srcs = builtins.fromJSON (builtins.readFile ./nix/sources.json);
  script = concatMapStringsSep "\n" updateSrc (map (x: srcs."${x}") sourceNames);
  updateSrc = src:
    if src ? owner && src ? repo && src ? rev
    then ''
        sed -e 's`\(git::https://github.com/${src.owner}/${src.repo}.git.*ref=\)........................................`\1'"${src.rev}\`" -i ${filesSh}
      ''
    else "";
in script
EOE
  )" --arg sourceNames "$1" --argstr filesSh "$2" --json | jq -r .)"
}

update-summarize() {
  echo 1>&2 "update: Up to date for:"

  # accurate:
  # jq -r <./nix/sources.json '. | to_entries | map ("update:   \(.key):  \(.value.branch)@\(.value.owner) (\(.value.repo))\n") | add | rtrimstr("\n")'
  # readable:
  jq -r <./nix/sources.json '. | to_entries | map ("update:   \(.value.owner)/\(.value.repo)@\(.value.branch)\n") | add | rtrimstr("\n")'
}