{
  description = "Repository for workshop notes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./treefmt.nix ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem =
        { self', pkgs, ... }:
        {
          packages.default = pkgs.callPackage ./template.nix { };

          devShells.default = pkgs.mkShell {
            packages = [ pkgs.just ];
            inputsFrom = [ self'.packages.default ];
          };
        };
    };
}
