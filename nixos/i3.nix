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
    excludePackages = with pkgs;[
      pkgs.xterm
      pkgs.nano
    ];
    windowManager.i3 = {
      configFile=null;
      enable = true;
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
