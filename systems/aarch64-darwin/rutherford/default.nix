{ pkgs, ... }: {
  networking.hostName = "rutherford";
  users.users.forrest.packages = [
    pkgs.rclone
  ];
}
