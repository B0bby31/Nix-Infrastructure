let
  mkLockedAttrs = builtins.mapAttrs (_: value: {
    Value = value;
    Status = "locked";
  });

  mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

  mkExtensionEntry = {
    id,
    pinned ? false,
  }: let
    base = {
      install_url = mkPluginUrl id;
      installation_mode = "force_installed";
    };
  in
    if pinned
    then base // {default_area = "navbar";}
    else base;

in {
  AutofillAddressEnabled = true;
  AutofillCreditCardEnabled = false;
  DisableAppUpdate = true;
  DisableFeedbackCommands = true;
  DisableFirefoxStudies = true;
  DisablePocket = true; # save webs for later reading
  DisableTelemetry = true;
  DontCheckDefaultBrowser = true;
  OfferToSaveLogins = false;
  PasswordManagerEnabled = false;
  PromptForDownloadLocation = false;
  EnableTrackingProtection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    Fingerprinting = true;
    EmailTracking = true;
    SuspectedFingerprinting = true;
    BaselineExceptions = true; # Hmm what does this really mean tho?
  };
  SanitizeOnShutdown = {
    FormData = true;
    Cache = true;
  };
  ExtensionSettings = {
    "*" = {
      blocked_install_message = "Install it declaritively in your nix config";
      installation_mode = "blocked";
    };
    "uBlock0@raymondhill.net" = mkExtensionEntry {
      id = "ublock-origin";
      pinned = true;
    };
    "jid1-BoFifL9Vbdl2zQ@jetpack" = mkExtensionEntry {
      id = "decentraleyes";
    };
    "addon@darkreader.org" = mkExtensionEntry {
      id = "darkreader";
      pinned = true;
    };
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = mkExtensionEntry {
      id = "bitwarden-password-manager";
      pinned = true;
    };
    "addon@simplelogin" = mkExtensionEntry {
      id = "simplelogin";
      pinned = true;
    };
  };
}
