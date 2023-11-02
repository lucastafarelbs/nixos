# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [];

#  home.activation = {
#    myActivationAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
#      $DRY_RUN_CMD rm -r $VERBOSE_ARG \
#          $HOME/.config/i3/config
#    '';
#  };

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "qolab";
    homeDirectory = "/home/qolab";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    htop
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "lucastafarelbs";
    userEmail = "lucastafarelbs@gmail.com";
  };

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };
  xsession.windowManager.i3 = {
    enable = true;
    config = null;
  };

  home.file = {
    ".config/i3/config" = {
      source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath ./i3);
      target = ".config/i3/config"; recursive = true;
    };
    ".config/i3/i3status-rust.toml".source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath ./i3status-rust.toml);
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
