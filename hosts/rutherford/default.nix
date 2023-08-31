{ config, lib, pkgs, ... }: {

  imports = [ ../../darwin ];

  networking.hostName = "rutherford";

}
