{ inputs, utils, ... }: {
    perSystem =
        {
            lib,
            pkgs,
            system,
            ...
        }:
        let
            inherit (lib.filesystem) packagesFromDirectoryRecursive;

            mkZoteroAddon =
                {
                    stdenvNoCC ? pkgs.stdenvNoCC,
                    pname,
                    version,
                    src,
                    addonId,
                    meta ? { },
                    ...
                }:
                stdenvNoCC.mkDerivation {
                    inherit pname version src;

                    preferLocalBuild = true;
                    allowSubstitutes = true;

                    buildCommand = ''
                        dst="$out/share/zotero/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
                        mkdir -p "$dst"
                        install -v -m644 "$src" "$dst/${addonId}.xpi"
                    '';

                    inherit meta;
                };

            base = pkgs // {
                inherit inputs;
                inherit (utils) timestampToDate;
            };
            callPackage = lib.callPackageWith base;
            callYaziPlugin = lib.callPackageWith (base // { inherit (pkgs.yaziPlugins) mkYaziPlugin; });
            callZoteroAddon = lib.callPackageWith (base // { inherit mkZoteroAddon; });
        in
        {
            _module.args.pkgs = import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };

            legacyPackages =
                packagesFromDirectoryRecursive {
                    inherit callPackage;
                    directory = ./pkgs/by-name;
                }
                // {
                    espansoPackages = packagesFromDirectoryRecursive {
                        inherit callPackage;
                        directory = ./pkgs/espansoPackages;
                    };
                }
                // {
                    fonts = packagesFromDirectoryRecursive {
                        inherit callPackage;
                        directory = ./pkgs/fonts;
                    };
                }
                // {
                    yaziPlugins = packagesFromDirectoryRecursive {
                        callPackage = callYaziPlugin;
                        directory = ./pkgs/yaziPlugins;
                    };
                }
                // {
                    zoteroAddons = packagesFromDirectoryRecursive {
                        callPackage = callZoteroAddon;
                        directory = ./pkgs/zoteroAddons;
                    };
                };
        };

}
