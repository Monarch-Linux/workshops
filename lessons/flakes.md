# Nix Flakes

## Basic anatomy of a flake

```nix
{
  description = "A very cool project";

  inputs = {
    # full format
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-24.11";
    };
    # url-like shorthand
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      # outputs are defined here
    };
}
```

https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-flake.html#flake-references

## Flake outputs

```nix
{
  # Executed by `nix flake check`
  checks."<system>"."<name>" = derivation;
  # Executed by `nix build .#<name>`
  packages."<system>"."<name>" = derivation;
  # Executed by `nix build .`
  packages."<system>".default = derivation;
  # Executed by `nix run .#<name>`
  apps."<system>"."<name>" = {
    type = "app";
    program = "<store-path>";
  };
  # Executed by `nix run . -- <args?>`
  apps."<system>".default = {
    type = "app";
    program = "...";
  };

  # Formatter (alejandra, nixfmt or nixpkgs-fmt)
  formatter."<system>" = derivation;
  # Overlay, consumed by other flakes
  overlays."<name>" = final: prev: { };
  # Default overlay
  overlays.default = final: prev: { };
  # Nixos module, consumed by other flakes
  nixosModules."<name>" =
    { config, ... }:
    {
      options = { };
      config = { };
    };
  # Default module
  nixosModules.default =
    { config, ... }:
    {
      options = { };
      config = { };
    };
  # Used with `nixos-rebuild switch --flake .#<hostname>`
  # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
  nixosConfigurations."<hostname>" = { };
  # Used by `nix develop .#<name>`
  devShells."<system>"."<name>" = derivation;
  # Used by `nix develop`
  devShells."<system>".default = derivation;
  # Used by `nix flake init -t <flake>#<name>`
  templates."<name>" = {
    path = "<store-path>";
    description = "template description goes here?";
  };
  # Used by `nix flake init -t <flake>`
  templates.default = {
    path = "<store-path>";
    description = "";
  };
}
```

## Exposing packages in a basic flake

Packages are system specific

```nix
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
```

Output of `nix flake show`:

```
└───packages
    └───x86_64-linux
        └───hello: package 'hello'
```

## Cross platform

We can create a function that produces the necessary structure for multiple systems

```nix
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
```

Output of `nix flake show --all-systems`:

```
└───packages
    ├───aarch64-linux
    │   └───hello: package 'hello'
    └───x86_64-linux
        └───hello: package 'hello'
```

## flake-parts

Doing things this way can be unnecessarily complicated! `flake-parts` is a library that can take care of this busy work and more!
`flake-parts` is becoming more popular, but is still a bit of a hidden gem.

```nix
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
```

Output of `nix flake show --all-systems`:

```
└───packages
    ├───aarch64-linux
    │   └───hello: package 'hello'
    └───x86_64-linux
        └───hello: package 'hello'
```