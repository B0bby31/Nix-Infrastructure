{ self, inputs, ... }: {
  flake.modules.homeManager.zen = { lib, pkgs, config, ... }: {
    imports = [
      inputs.zen-browser.homeModules.beta
    ];

    programs.zen-browser = {
      # A nice example can be found at https://github.com/skifli/nixos
      enable = true;
      setAsDefaultBrowser = true;
      languagePacks = ["en-US"];
      policies = import ./policies-config.nix;
      
      profiles.default = rec {
        id = 0;
        name = "default";
        isDefault = true;

        # When uninstalling also remove settings from settings.nix
        mods = [
          "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better find bar
          "b51ff956-6aea-47ab-80c7-d6c047c0d510" # Disable status
          "803c7895-b39b-458e-84f8-a521f4d7a064" # Hide inactive workspaces
          "87196c08-8ca1-4848-b13b-7ea41ee830e7" # Better tab preview
          "642854b5-88b4-4c40-b256-e035532109df" # Transparent Zen
          "e34745fd-2b7f-4c16-b03a-6e29e5c3f20a" # Hide Toolbar
        ];

        # I have this here, but let stylix manage this
        #userChrome = builtins.readFile (config.home.homeDirectory + "/.cache/noctalia/zen-browser/zen-userChrome.css");
        #userContent = builtins.readFile (config.home.homeDirectory + "/.cache/noctalia/zen-browser/zen-userContent.css");
        
        # Configure Search providers
        search = import ./search.nix { inherit pkgs; };
   
        # Force creation of these containers and workspaces
        containersForce = true;
        spacesForce = true;
        pinsForce = true;

        containers = import ./containers.nix;
        pins = import ./pins.nix;
        spaces = import ./spaces.nix;
        settings = import ./settings.nix;        


           extraConfig = ''
              // BETTERFOX
              //${builtins.readFile "${inputs.betterfox}/zen/user.js"}
              
              /****************************************************************************
               * START: MY OVERRIDES                                                      *
              ****************************************************************************/
              // Visit https://github.com/yokoffing/Betterfox/wiki/Common-Overrides
              // Visit https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening
              // Enter your personal overrides below this line:

              // Common Overrides
              user_pref("permissions.default.geo", 0); // https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#location-requests
              user_pref("permissions.default.desktop-notification", 0); // https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#site-notifications

              // Optional Hardening
              // Below 2 - https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#firefox-sync--view
              user_pref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}"); // PREF: disable the Firefox View tour from popping up
              // Below 3 - https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#password-credit-card-and-address-management
              user_pref("signon.rememberSignons", false); // PREF: disable login manager
              user_pref("extensions.formautofill.addresses.enabled", false); // PREF: disable address and credit card manager
              user_pref("extensions.formautofill.creditCards.enabled", false); // PREF: disable address and credit card manager
              // TODO - Future? https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#secure-dns
              // Below 3 - https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#downloads
              user_pref("browser.download.useDownloadDir", false); // PREF: ask where to save every file
              user_pref("browser.download.always_ask_before_handling_new_types", false); // PREF: ask whether to open or save new file types
              user_pref("extensions.postDownloadThirdPartyPrompt", false); // PREF: display the installation prompt for all extensions
              // Below 1 - https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening#public-key-pinning
              user_pref("security.cert_pinning.enforcement_level", 2); // PREF: enforce certificate pinning, [ERROR] MOZILLA_PKIX_ERROR_KEY_PINNING_FAILURE, 1 = allow user MiTM (such as your antivirus) (default), 2 = strict

              /****************************************************************************
               * SECTION: SMOOTHFOX                                                       *
              ****************************************************************************/
              // Visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
              // Enter your scrolling overrides below this line:
              // Section taken from https://github.com/yokoffing/Betterfox/blob/eee6e58b2b0ee10a59efb6586a5db07ae181d8c7/Smoothfox.js#L28
              // Advice at https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#scrolling
              
              /****************************************************************************************
               * OPTION: INSTANT SCROLLING (SIMPLE ADJUSTMENT)                                       *
              ****************************************************************************************/
              // Recommended for 60hz+ displays
              user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
              user_pref("general.smoothScroll", true); // DEFAULT
              user_pref("mousewheel.default.delta_multiplier_y", 60); // 250-400; adjust this number to your liking 
            '';
      };
    };
  };
}
