{
    description = "My pkgs";

    outputs =
        { self, ... }@args:
        let
            inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
        in
        inputs.flake-parts.lib.mkFlake { inherit inputs self; } {
            systems = import inputs.systems;

            _module.args.utils = import ./utils.nix;

            imports = [
                ./packages.nix
                ./devshell.nix
                ./treefmt.nix
            ];

            flake = {
                overlays.default =
                    final: prev:
                    (prev.lib.packagesFromDirectoryRecursive {
                        callPackage = prev.lib.callPackageWith (
                            final
                            // {
                                inherit inputs;
                                inherit (self._module.args.utils) timestampToDate;
                            }
                        );
                        directory = ./pkgs/by-name;
                    });

                homeModules = import ./modules/home-manager;
            };
        };
}
