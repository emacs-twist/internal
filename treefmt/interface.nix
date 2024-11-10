{
  lib,
  ...
}:
{
  options = {
    formatters = {
      enable = lib.mkEnableOption "Enable the default formatters";
    };

    linters = {
      enable = lib.mkEnableOption "Enable the linters";
    };
  };
}
