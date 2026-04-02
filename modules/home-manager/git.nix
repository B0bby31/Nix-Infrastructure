{
  flake.modules.homeManager.git = {
  programs.git = {
    enable = true;
    userName = "B0bby31";
    userEmail = "github.cornfield155@simplelogin.com";
    
    # Extra configuration (replaces .gitconfig entries)
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      core.editor = "nano";
    };

    # Handy aliases
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
    };

    # Ignore files globally
    ignores = [ ".DS_Store" "*.swp" ];
  };
  };
}
