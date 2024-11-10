{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        {
          system,
          treefmt-default,
          treefmt-lint,
          treefmt-format,
          pkgs,
          ...
        }:
        let
          mkTreefmt =
            options:
            (inputs.treefmt-nix.lib.evalModule pkgs {
              imports = [
                ./treefmt
                options
              ];
            }).config.build;
        in
        {
          _module.args.pkgs = nixpkgs.legacyPackages.${system};

          _module.args.treefmt-default = mkTreefmt {
            formatters.enable = true;
            linters.enable = true;
          };

          _module.args.treefmt-lint = mkTreefmt {
            formatters.enable = false;
            linters.enable = true;
          };

          _module.args.treefmt-format = mkTreefmt {
            formatters.enable = true;
            linters.enable = false;
          };

          packages = {
            default-checks = treefmt-default.wrapper;
            linters = treefmt-lint.wrapper;
            formatters = treefmt-format.wrapper;
          };

          checks = {
            treefmt = treefmt-default.check inputs.self;
          };

          formatter = treefmt-default.wrapper;
        };
    };
}
