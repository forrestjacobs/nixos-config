{ lib, pkgs, config, inputs, hostName, ... }:

let
  root =
    if pkgs.stdenv.isDarwin
    then "${config.home.homeDirectory}/.config/darwin"
    else "/etc/nixos";
  link = path: config.lib.file.mkOutOfStoreSymlink "${root}/hm/${path}";
  home-bin = (pkgs.stdenv.mkDerivation {
    name = "home-bin";
    src = ./bin;
    installPhase = ''
      mkdir -p $out/bin
      cp * $out/bin
    '';
  });
  gencolor = key: y:
    let
      hexToInt = digit: lib.toInt (
        builtins.replaceStrings
          [ "a" "b" "c" "d" "e" "f" ]
          [ "10" "11" "12" "13" "14" "15" ]
          digit
      );
      toComponent = byte:
        let hex = lib.toHexString (lib.max (lib.min byte 255) 0);
        in if builtins.stringLength == 0 then "0${hex}" else hex;
      hash = builtins.hashString "md5" key;
      hue =
        (hexToInt (builtins.substring 0 1 hash)) * 16 +
        (hexToInt (builtins.substring 1 1 hash));

      chroma = y * 2 / 3;

      xPart = (lib.mod (hue * 6) 510) - 255;
      x = chroma * (if xPart < 0 then 255 + xPart else 255 - xPart) / 255;

      r = if hue < 43 then chroma else if hue < 86 then x else if hue < 171 then 0 else if hue < 213 then x else chroma;
      g = if hue < 43 then x else if hue < 128 then chroma else if hue < 171 then x else 0;
      b = if hue < 86 then 0 else if hue < 128 then x else if hue < 213 then chroma else x;

      m = y - (54 * r) / 255 - (182 * g) / 255 - (18 * b) / 255;
    in
    "${toComponent (r + m)}${toComponent (g + m)}${toComponent (b + m)}";

in
{

  home.stateVersion = "22.11";

  home.packages = [
    home-bin
    pkgs.bat
    pkgs.delta
    pkgs.exa
    pkgs.fd
    pkgs.fishPlugins.hydro
    pkgs.gitui
    pkgs.htop
    pkgs.jq
    pkgs.lsof
    pkgs.mosh
    pkgs.ncdu
    pkgs.nil
    pkgs.nix-tree
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.bash-language-server # bash lsp
    pkgs.openssh
    pkgs.p7zip
    pkgs.patchutils
    pkgs.rnix-lsp # nix lsp
    pkgs.tmux
    pkgs.unzip
  ];

  programs.direnv.enable = true;

  programs.fzf.enable = true;

  programs.fish = {
    enable = true;

    functions = {
      l = "bat -p $argv";
      ll = "exa -aagl $argv";
      lll = "exa -glT --level=2 $argv";
      remote = {
        argumentNames = [ "target" ];
        body = ''ssh -t "$target" term'';
      };
    };
    shellAbbrs = {
      garbage = "sudo nix-collect-garbage --delete-old";
      rebuild = "sudo nixos-rebuild switch";
      se = "sudoedit";
    };
  };

  programs.git = {
    enable = true;
    userName = "Forrest Jacobs";
    userEmail = lib.mkDefault "forrestjacobs@gmail.com";
    extraConfig = {
      diff.colorMoved = "default";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      pull.ff = "only";
    };
    ignores = [
      ".DS_Store"
      "*.forrest"
      "*.forrest.*"
    ];
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
    };
  };

  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    settings = {
      theme = "base16_transparent";
      editor = {
        color-modes = true;
        cursor-shape.insert = "bar";
        indent-guides.render = true;
        line-number = "relative";
      };
    };
  };

  xdg.configFile = {
    "fish/conf.d/50-main.fish".source = link "fish/config.fish";
    kitty.source = link "kitty";
    "tmux/tmux.conf".text = ''
      source ${link "tmux/tmux.conf"}
      set -g status-right "#[bg=#${gencolor hostName 64}] #h #[bg=default] "
    '';
  };

}
