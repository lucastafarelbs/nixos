{ inputs, config, pkgs, callPackage, lib, ... }:

{
  environment.pathsToLink = ["/libexec"];
  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    layout = "br";
    xkbVariant = "";
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "none+i3";
    };
    libinput={
      enable = true;
    };
    windowManager.i3 = {
      enable = true;
      configFile = ./i3-config;
      extraPackages = with pkgs; [
        dmenu
	rofi
	i3status-rust
	i3lock
	nitrogen
      ];
    };
  };
}
