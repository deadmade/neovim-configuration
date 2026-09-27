inputs: let
  inherit (inputs.nixCats) utils;
in {
  nvim = { pkgs, ... }: {
    settings = {
      wrapRc = true;
      aliases = [ "vim" "vi" ];
    };
    categories = {
      general = true;
    };
  };
}
