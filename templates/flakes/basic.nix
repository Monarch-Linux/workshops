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
