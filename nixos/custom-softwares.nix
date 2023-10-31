{ pkgs, config, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      git
      telegram-desktop
      alacritty
      flameshot
      discord
      dbeaver
    ];
  };
}
