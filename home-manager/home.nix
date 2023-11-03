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
  imports = [
    ./i3.nix
  ];

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
    playerctl #control play, pause, next, prev...
    lshw
    pciutils
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

  # picom = transparency and corner radius
  services.picom = { 
    enable = true;
    inactiveOpacity = 0.85;
    activeOpacity = 1;
    settings = { 
      "corner-radius" = 5;
    };
  };
  
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
