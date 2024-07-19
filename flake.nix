{
  description = "basic flake-utils";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";


  outputs = { self, nixpkgs, flake-utils, ... }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };


          woodpecker = pkgs.woodpecker-server.overrideAttrs
            {
              src = pkgs.fetchFromGitHub {
                owner = "woodpecker-ci";
                repo = "woodpecker";
                rev = "v2.6.0";
                sha256 = "sha256-SuTizOHsj1t4WovbOX5MuMZixbPo7TyCnD6nnf62/H4=";
              };
              vendorHash = null;
              version = "2.6.0";
              pname = "woodpecker-server";

              subPackages = "cmd/server";

              CGO_ENABLED = 1;

              patches = [
                ./0001-yet.patch
                ./0002-not-push-events.patch
              ];

            };



        in
        {
          packages.default = woodpecker;


        })
    );
}
