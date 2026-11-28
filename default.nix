let
    flake = import ./flake.nix;
    outputs = flake.outputs { self = outputs; };
in
outputs
