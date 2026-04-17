{ pkgs, ... }:

{
  force = true;
  default = "ddg";
  privateDefault = "ddg";
  order = [
    "ddg"
    "Startpage"
    "NixOS Packages"
    "NixOS Options"
    "NixOS Wiki"
    "Home Manager"
    "My NixOS"
    "Noogle"
    "google"
  ];
  engines =
    let
      nix-icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    in
    {
      "Startpage" = {
        urls = [
          {
            template = "https://www.startpage.com/sp/search?query={searchTerms}";
          }
        ];
        icon = "https://www.startpage.com/sp/cdn/favicons/favicon-gradient.ico";
        definedAliases = [ "@sp" ];
        updateInterval = 24 * 60 * 60 * 1000;
      };
      "NixOS Packages" = {
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = nix-icon;
        definedAliases = [
          "@np"
          "@nixpkgs"
        ];
      };
      "NixOS Options" = {
        urls = [
          {
            template = "https://search.nixos.org/options";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = nix-icon;
        definedAliases = [
          "@no"
          "@nixopts"
        ];
      };
      "NixOS Wiki" = {
        urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
        icon = nix-icon;
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = [ "@nw" ];
      };
      "Home Manager" = {
        urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
        icon = nix-icon;
        definedAliases = [
          "@hm"
          "@home"
          "'homeman"
        ];
      };
      "My NixOS" = {
        urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
        icon = nix-icon;
        definedAliases = [
          "@mn"
          "@nx"
          "@mynixos"
        ];
      };
      "Noogle" = {
        urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
        icon = nix-icon;
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = [
          "@noogle"
          "@ng"
        ];
      };
      "ChatGPT" = {
        urls = [
          { template = "https://chat.openai.com/?q={searchTerms}"; }
        ];
        icon = "https://chatgpt.com/cdn/assets/favicon-eex17e9e.ico";
        definedAliases = [ "@cg" "@chatgpt" ];
      };
      "bing".metaData.hidden = true;
      "ebay".metaData.hidden = true;
      "Perplexity".metaData.hidden = true;
    };
}
