{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    fedimint = {
      url = "github:fedimint/fedimint?rev=b2731b0d3068bb7eb8c8e721cf4abe504b07b569";
    };
  };
  outputs = { self, nixpkgs, flake-utils, fedimint }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        fmLib = fedimint.lib.${system};
      in
      {
        devShells = fmLib.devShells // {
          default = fmLib.devShells.default.overrideAttrs (prev: {
            nativeBuildInputs = [
              pkgs.mprocs
              pkgs.nodejs
              pkgs.yarn
              fedimint.packages.${system}.devimint
              fedimint.packages.${system}.gateway-pkgs
              fedimint.packages.${system}.fedimint-pkgs
            ] ++ prev.nativeBuildInputs;
          });
        };
      });
}
