let
  spaces = import ./spaces.nix;
in {
        "GitHub" = {
          id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
          workspace = spaces."Homelab".id;
          url = "https://github.com";
          position = 101;
          isEssential = false;
        };
        "WhatsApp Web" = {
          id = "1eabb6a3-911b-4fa9-9eaf-232a3703db19";
          workspace = spaces."Personal".id;
          url = "https://web.whatsapp.com/";
          position = 102;
          isEssential = false;
        };
}
