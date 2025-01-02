{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.foo.virtualization;
in
{
  options = {
    foo.virtualization = {
      enable = lib.mkEnableOption "virtualization";
      users = lib.mkOption {
        description = "Users to add to libvirt group";
        type = with lib.types; listOf str;
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };

    users.users = builtins.listToAttrs (
      map (user: lib.nameValuePair user { extraGroups = [ "libvirt" ]; }) cfg.users
    );
  };
}
