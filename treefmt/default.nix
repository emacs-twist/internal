{
  config,
  ...
}:
let
  enableFormat = config.formatters.enable;
  enableLint = config.linters.enable;
in
{
  imports = [
    ./interface.nix
  ];

  # See https://github.com/numtide/treefmt-nix#supported-programs for
  # supported programs
  config = {
    projectRootFile = ".git/config";

    # Nix
    programs.nixfmt.enable = enableFormat;
    programs.statix.enable = enableLint;
    programs.statix = {
      disabled-lints = [
        # `bool_comparison` causes false positives in the code base of
        # twist.nix. Nix is a dynamically typed language and doesn't support
        # optional types, so this hint should be disabled.
        "bool_comparison"
      ];
    };
    programs.deadnix.enable = enableLint;

    # GitHub Actions
    programs.actionlint.enable = enableLint;
  };
}
