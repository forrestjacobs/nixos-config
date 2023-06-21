{ config, lib, pkgs, inputs, ... }: {

  imports = [ ../../darwin ];

  networking.hostName = "rutherford";

}
