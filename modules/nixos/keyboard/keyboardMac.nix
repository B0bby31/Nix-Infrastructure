{ self, inputs, ... }: {
  flake.modules.nixos.keyboardMac = { lib, config, pkgs, ... }:
      let
        layoutName = "mac_intl_custom";
      in
      {
        services.xserver = {
          xkb.layout = layoutName;
          xkb.variant = layoutName;
          xkb.extraLayouts.${layoutName} = rec {
            description = "Programmers Dvorak with custom AltGr maps";
            symbolsFile = builtins.toFile "symbols-${layoutName}" ''
            xkb_symbols "${layoutName}" {
              include "gb(mac_intl)";
              name[Group1]="English (UK, mac_intl, no dead keys)";
              key <AE03> { [ 3, numbersign, threesuperior, numbersign ] };
              key <AC11> { [ apostrophe, quotedbl ] };
              key <TLDE> { [ grave, asciitilde ] };
            };
            '';
          };
       };
     };
}
