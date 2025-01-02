# Module arguments. Optional.
{
  config, # The configuration of the entire system.
  lib, # Library functions from nixpkgs.
  options, # All option declarations refined with all definition and declaration references.
  pkgs, # Package attribute set from nixpkgs, can be extended with nixpkgs.config.
  modulesPath, # The location of the module directory of nixpkgs.
  ...
}:

{
  imports = [
    # Paths to other modules. Compose this module out of smaller ones.
  ];

  options = {
    # Option declarations. Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
  };

  config = {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.
  };
}
