# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  gruvboxPlus = import ./gruvbox-plus.nix { inherit pkgs; };
in
{
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
    pciutils
    pavucontrol
    spotify
    helvum
    gsimplecal
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "lucastafarelbs";
    userEmail = "lucastafarelbs@gmail.com";
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

  #theming
  qt.enable = true;
  qt.platformTheme = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = "pkgs.adwaita-qt";

  gtk = {
    enable = true;
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";
    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";
    iconTheme.package = gruvboxPlus;
    iconTheme.name = "GruvboxPlus";
  };

  home.stateVersion = "23.05";
}
