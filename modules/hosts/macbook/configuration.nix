{ self, inputs, ... }: {
  flake.modules.nixos.macbookConfiguration = { config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      self.modules.nixos.macbookHardware
      self.modules.nixos.userCollin
      self.modules.nixos.niri
      self.modules.nixos.nixOptions
      self.modules.nixos.battery
      self.modules.nixos.dankShell
      self.modules.nixos.dankGreeter
      self.modules.nixos.stylix
      self.modules.nixos.nautilus
      # Include packages and configurations for apple macbook
      inputs.apple-silicon.nixosModules.apple-silicon-support
      inputs.nixos-asahi-framebuffer-compression.nixosModules.default
      # Include home manager
      inputs.home-manager.nixosModules.default
    ];

  # Macbook asahi things

  # Setting the firmware directory (IMPORTANT: When upgrading m1n1 I have to do this step >
  hardware.asahi.peripheralFirmwareDirectory = ../../../firmware;
  # Note: The snippet shows the default is 'config.hardware.asahi.enable'
  # So if you have this enabled, sound might already be on by default:
  hardware.asahi.enable = true;
  hardware.asahi.setupAsahiSound = true;

  boot.kernelParams = ["appledrm.show_notch=1"];

  # Boot related things

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.systemd-boot.configurationLimit = 5;

  # Give the mac gpu a consistent name
  services.udev.packages = let
        gpuPath = "dri/by-path/platform-406400000.gpu-card";
      in
      lib.singleton (
        pkgs.writeTextDir "lib/udev/rules.d/61-gpu-offload.rules" ''
          SYMLINK=="${gpuPath}", SYMLINK+="dri/gpuApple1"
        ''
      );

  # Boot from luks
  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/disk/by-uuid/09380b4a-d37c-477e-85f3-ef6693758dac";
      preLVM = true;
    };
  };

  # Enable Keyboard backlight during first boot stage
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = [ "pwm_apple" ];
  boot.initrd.systemd.services.backlight-keyboard-boot = {
    description = "Set the keyboard backlight";
    wantedBy = ["initrd.target"];
    before = [ "cryptsetup.target" ];

    # Ensure the service waits for the device to appear in the tree
    unitConfig.RequiresMountsFor = [ "/sys/class/leds/kbd_backlight" ];

    serviceConfig = {
      Type = "oneshot";
      # A small retry logic in the script can act as a safety net
      ExecStart = "/bin/sh -c 'while [ ! -d /sys/class/leds/kbd_backlight ]; do sleep 0.1; done; echo 20 > /sys/class/leds/kbd_backlight/brightness'";
    };
  };

  # General system config

  # Enable the use of flakes
  nix.settings.experimental-features = ["nix-command" "flakes" ];

  networking.hostName = "0x636F6C6C696E"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Swap (TODO this needs to be changed)
  swapDevices = lib.mkForce [];
  zramSwap.enable = true;

  # Select internationalisation properties.
  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };
  
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };



  # Things that need to be MOVED
  security.sudo.enable = true;

  programs.zsh.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    ];
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Enabling iwd
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  # Home manager setup
  home-manager = {
    users."collin" = self.homeConfigurations."collin";
    backupFileExtension = "backup";
  };


  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    bitwarden-desktop
    brightnessctl
  ];

  system.stateVersion = "25.11";

  };
}
