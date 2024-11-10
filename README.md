# Flake for Internal Use

This repository provides flake packages that wrap a set of formatters and
linters that should be used across emacs-twist (via
[treefmt-nix](https://github.com/numtide/treefmt-nix)).

It can be run locally with a single Nix command:

``` nix
nix run github:emacs-twist/internal#default-checks
```

Furthermore, this repository provides a [reusable GitHub Actions
workflow](https://docs.github.com/en/actions/sharing-automations/reusing-workflows)
that perform checks.

This is intended for maintaining the code quality, while minimizing the number
of flake inputs to each repository in the org.
