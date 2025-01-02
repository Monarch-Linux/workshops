{
  description = "A very cool project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      packages.x86_64-linux.hello = pkgs.stdenv.mkDerivation {
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
}
