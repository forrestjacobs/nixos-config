{ config, lib, pkgs, ... }: {

  options.services.update-system.enable =
    lib.mkEnableOption "Pull dot updates and rebuild system overnight";

  config = lib.mkIf config.services.update-system.enable {

    systemd.services.update-system = {
      description = "Pull dot updates and rebuild system";
      startAt = "4:30am";
      path = [
        pkgs.gitMinimal
        config.programs.ssh.package
      ];
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = "/etc/nixos";
      };
      script = let
        user-git = "${config.security.sudo.package}/bin/sudo -u forrest ${pkgs.git}/bin/git";
        rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
        readlink = "${pkgs.coreutils}/bin/readlink";
        shutdown = "${config.systemd.package}/bin/shutdown";
      in ''
        set -euo pipefail

        if [ "$(${user-git} branch --show-current)" != "main" ]; then
          echo "Not on main branch" 1>&2
          exit 1
        fi

        if ! ${user-git} diff --quiet || ! ${user-git} diff --staged --quiet; then
          echo "Detected local differences" 1>&2
          exit 1
        fi

        ${user-git} pull

        # Rebuild the same way as system.autoUpgrade
        # see https://github.com/NixOS/nixpkgs/blob/720e61ed8de116eec48d6baea1d54469b536b985/nixos/modules/tasks/auto-upgrade.nix#L198

        ${rebuild} boot
        booted="$(${readlink} /run/booted-system/{initrd,kernel,kernel-modules})"
        built="$(${readlink} /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

        if [ "''${booted}" = "''${built}" ]; then
          ${rebuild} switch
        else
          ${shutdown} -r +1
        fi
      '';
    };

  };

}
