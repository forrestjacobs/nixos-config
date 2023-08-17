{ config, lib, pkgs, ... }:

let
  update = pkgs.writeShellApplication {
    name = "update";
    runtimeInputs = [
      pkgs.gitMinimal
      config.programs.ssh.package
    ];
    text =
      let
        user-git = "${config.security.sudo.package}/bin/sudo -u forrest ${pkgs.gitMinimal}/bin/git -C /etc/nixos";
        rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
      in
      ''
        fail() {
          echo "Error:" "$@" 1>&2
          exit 1
        }

        if [ "$EUID" -ne 0 ]; then
          fail "Must run as root"
        fi

        if [ "$(${user-git} branch --show-current)" != "main" ]; then
          fail "/etc/nixos is not on main branch" 1>&2
        fi

        if ! ${user-git} diff --quiet || ! ${user-git} diff --staged --quiet; then
          fail "/etc/nixos has local differences" 1>&2
        fi

        if [ "$(${user-git} rev-list ^origin/main HEAD --count)" != "0" ]; then
          fail "/etc/nixos is ahead of origin/master"
        fi

        ${user-git} pull
        ${rebuild} switch
      '';
  };

in
{

  options.services.update-system.enable =
    lib.mkEnableOption "Pull dot updates and rebuild system overnight";

  config = {

    environment.systemPackages = [ update ];

    systemd.services.update-system = lib.mkIf config.services.update-system.enable {
      description = "Pull dot updates and rebuild system";
      startAt = "4:30";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${update}/bin/update";
      };
    };

    # see https://discourse.nixos.org/t/when-is-a-reboot-necessary-after-auto-upgrade/15254/4
    systemd.services.reboot-if-changed = lib.mkIf config.services.update-system.enable {
      description = "Reboot for kernel changes";
      startAt = "5:30";
      serviceConfig.Type = "oneshot";
      script =
        let
          readlink = "${pkgs.coreutils}/bin/readlink";
          shutdown = "${config.systemd.package}/bin/shutdown";
        in
        ''
          set -euo pipefail

          booted="$(${readlink} /run/booted-system/{initrd,kernel,kernel-modules})"
          current="$(${readlink} /run/current-system/{initrd,kernel,kernel-modules})"

          if [ "''${booted}" != "''${current}" ]; then
            ${shutdown} -r +1
          fi
        '';
    };

  };

}
