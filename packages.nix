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
      lua-dev = true;
      nix-dev = true;
      config-langs = true;

      core-plugins = true;

      have_nerd_font = true;
    };
  };
}
