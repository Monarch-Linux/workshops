{
  description = "A very cool project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      packages = forAllSystems (pkgs: {
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
      });
    };
}
