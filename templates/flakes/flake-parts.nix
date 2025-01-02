{
  description = "A very cool project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      flake = {
        # normal flake attributes go here!
      };

      perSystem =
        { pkgs, ... }:
        {
          packages = {
            hello = pkgs.stdenv.mkDerivation {
              name = "hello";
              src = pkgs.writeTextDir "hello.c" ''
                #include <stdio.h>
                int main() {
                  printf("Hello World!\n");
                  return 0;
                }
              '';
              buildPhase = "gcc -o hello ./hello.c";
              installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
            };
          };
        };
    };
}
