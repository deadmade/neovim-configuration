 inputs: let
  inherit (inputs.nixCats) utils;
  in {
      # These are the names of your packages
      # you can include as many as you wish.
      nvim = { pkgs , ... }: {
        # they contain a settings set defined above
        # see :help nixCats.flake.outputs.settings
        settings = {
          wrapRc = true;
          # IMPORTANT:
          # your alias may not conflict with your other packages.
          aliases = [ "vim" ];
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
        };
        # and a set of categories that you want
        # (and other information to pass to lua)
        categories = {
          general = true;
          gitPlugins = true;
          customPlugins = true;
          test = true;

          kickstart-autopairs = true;
          kickstart-neo-tree = true;
          kickstart-debug = true;
          kickstart-lint = true;
          kickstart-indent_line = true;

          # this kickstart extra didnt require any extra plugins
          # so it doesnt have a category above.
          # but we can still send the info from nix to lua that we want it!
          kickstart-gitsigns = true;

          # we can pass whatever we want actually.
          have_nerd_font = false;

          example = {
            youCan = "add more than just booleans";
            toThisSet = [
              "and the contents of this categories set"
              "will be accessible to your lua with"
              "nixCats('path.to.value')"
              "see :help nixCats"
              "and type :NixCats to see the categories set in nvim"
            ];
          };
        };
      };
    }
