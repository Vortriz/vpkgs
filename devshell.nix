{ inputs, ... }: {
    perSystem =
        { pkgs, system, ... }:
        {
            devShells.default = pkgs.mkShellNoCC {
                packages =
                    with pkgs;
                    [
                        nix-init
                        nix-fast-build
                    ]
                    ++ [ inputs.tack.packages.${system}.default ];

                TACK_NIX_CONF_TOKENS = 1;
            };
        };
}
