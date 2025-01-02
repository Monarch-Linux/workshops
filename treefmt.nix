{ inputs, ... }:

{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    projectRootFile = "flake.nix";
    settings.global.excludes = [ "lessons/*" ];

    programs.nixfmt.enable = true;
    programs.just.enable = true;
    programs.ruff.enable = true;

    programs.prettier = {
      enable = true;
      includes = [
        "*.md"
        "*.md.jinja"
      ];

      settings.overrides = [
        {
          files = [ "*.md.jinja" ];
          options.parser = "markdown";
        }
      ];
    };
  };
}
