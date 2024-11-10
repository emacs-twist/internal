{ inputs, ... }:
{
  perSystem =
    {
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
            ./.
            options
          ];
        }).config.build;
    in
    {
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
}
