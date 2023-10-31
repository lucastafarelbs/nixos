{ pkgs, ... }
{
  enviroment.systemPackages = with pkgs; [
    git
    telegram-desktop
    alacritty
    flameshot
  ];
}
