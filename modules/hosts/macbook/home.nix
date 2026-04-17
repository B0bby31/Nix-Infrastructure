{ self, inputs, ... }: {
  flake.homeConfigurations."collin" = { pkgs, ... }: {
    home.username = "collin";
    home.homeDirectory = "/home/collin";

    # Import my homeManager modules here
    imports = with self.modules.homeManager; [
            git
            zen
            dankShellMacbook
            niriMacbook
            stylixMacbook
            alacritty
            # vscode
            # passwordManager
          ];

    home.stateVersion = "25.11"; # Please read the comment before changing.

    home.packages = [
      # Packges with no config are added here
      pkgs.psst
    ];

    gtk.gtk4.theme = null; 

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {};

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
}
