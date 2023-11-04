{ inputs, config, pkgs, callPackage, lib, ... }:

# let
#  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload"  ''
#  export __NV_PRIME_RENDER_OFFLOAD=1
#  export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
#  export __GLX_VENDOR_LIBRARY_NAME=nvidia
#  export __VK_LAYER_NV_optimus=NVIDIA_only
#  exec "$@"
#  '';
#in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./i3.nix
    ];
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # services.xserver.videoDrivers = [ "amdgpu"];
  # enabling amdgpu and nvidia
   services.xserver.videoDrivers = [ "amdgpu" "nvidia"];
   hardware.nvidia = {
    # Modesetting is required following nixos docs
    modesetting.enable = true;

    powerManagement = {
        enable = true;
        # finegrained = true;
    };
    # opensource kernel module (for newer gpus)
    open = true;
    prime = {
    #  offload.enable = true;
    #  offload.enableOffloadCmd = true;
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:116:0:0";
    };
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enabling flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fonts.fonts = with pkgs; [
    font-awesome
    fira-code
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "thrive"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.qolab = {
    isNormalUser = true;
    description = "qolab";
    extraGroups = [ "networkmanager" "wheel" "power" "audio" "video" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    telegram-desktop
    alacritty
    firefox
    flameshot
    home-manager
    discord
    btop
    arandr
    brightnessctl
    xfce.thunar
  ];
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  
  # Enabling audio
  sound.enable = false;
  sound.mediaKeys.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  system.stateVersion = "23.05"; # Did you read the comment?

}
