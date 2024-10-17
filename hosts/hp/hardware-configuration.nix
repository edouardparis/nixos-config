# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd" "amdgpu"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fc0d055a-c554-4394-821d-80ee5ad856d3";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-3fe478ec-3d35-4767-ae80-273dd1d311df".device = "/dev/disk/by-uuid/3fe478ec-3d35-4767-ae80-273dd1d311df";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BEB3-626D";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/a00a7e39-5a20-416b-b845-661116f1af78";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    pkgs.mesa.drivers
    pkgs.vulkan-loader
    pkgs.vulkan-validation-layers
    pkgs.vulkan-extension-layer
  ];
  hardware.bluetooth.enable = true;
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  # hardware.pulseaudio.package = pkgs.pulseaudioFull;
}
