{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings = {
        user.name = "B0bby31";
        user.email = [ "collin@plutode.com" ];
    
        # Extra configuration (replaces .gitconfig entries)
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = true;
          core.editor = "nano";
        };

        # Handy aliases
        aliases = {
          st = "status";
          co = "checkout";
          br = "branch";
        };
      };
      # Ignore files globally
      ignores = [ ".DS_Store" "*.swp" ];
    };
  };
}
