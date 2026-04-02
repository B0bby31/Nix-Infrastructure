{ self, inputs, ... }: {
  flake.nixosModules.macbookConfiguration = { config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      self.nixosModules.macbookHardware
      self.nixosModules.userCollin
      # Include packages and configurations for apple macbook
      inputs.apple-silicon.nixosModules.apple-silicon-support
      #inputs.nixos-asahi-framebuffer-compression.nixosModules.default
      # Include home manager
      inputs.home-manager.nixosModules.default
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  security.sudo.enable = true;

  programs.zsh.enable = true;

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

  # Enable the use of flakes
  nix.settings.experimental-features = ["nix-command" "flakes" ];

  networking.hostName = "0x636F6C6C696E"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Setting the firmware directory (IMPORTANT: When upgrading m1n1 I have to do this step again see issue 299)
  hardware.asahi.peripheralFirmwareDirectory = ../../../firmware;
  # Note: The snippet shows the default is 'config.hardware.asahi.enable'
  # So if you have this enabled, sound might already be on by default:
  hardware.asahi.enable = true;
  hardware.asahi.setupAsahiSound = true;
  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Swap (TODO this needs to be changed)
  swapDevices = lib.mkForce [];
  zramSwap.enable = true;

  # Enabling iwd
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Home manager setup
  home-manager = {
    users = {
      "collin" = {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "collin";
  home.homeDirectory = "/home/collin";

  imports = with self.modules.homeManager; [
            git
            # adminTools
            # vscode
            # passwordManager
          ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/collin/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nano";
    SSH_AUTH_SOCK = "/home/collin/.bitwarden-ssh-agent.sock";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history.size = 10000;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
};
 
    };
    backupFileExtension = "backup";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    bitwarden-desktop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

};


}
