# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  coreModule = import ./core.nix {
    inherit lib;   # Pass the lib attribute from the parent scope.
    inherit pkgs;  # Pass the pkgs attribute from the parent scope.
  };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dennis = {
    isNormalUser = true;
    description = "Dennis Schroeder";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      k3s
      iptables
      coreModule
      
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDR8FGe66mF5PFKUF3wBXB3hdL1QeY706phvtaC/abJa0xdNq/t/QKuxhbeeya+xYp2MBFsnfwobWtbVgD1fS/UlEJxz+ex0WDdOtqAJ+9iWQLC9JCtcFD0NoMMTPbEulWztdcFrClDSUBm/kMs94a5gIdf8p6gRHMqNzVAzpaxU7pL32rezHp6JtphVdGSbp8ZW2Aq7oHEwcm4R0AeJR75dYcJdu2v+t5g7c9eGm0cqZnWl5KEfqHjyuC+zyPlSGyVDYI3zcKTtUY/0dT9VPhy4+QYt+k8/lY98mvvoWG6Mo3V9gQiJMBNYBn/ktX761LWzUJBh21dLc5KGkoo1Bw7PqyJz0U67fl1ti/ITCsNFWo9M7Nn8fG8beDV2v61C9K4i3oQKep0OocdcdXCIIDde0SQIwQqowWGLs583WiZo6Sy8dnU3u3C7df6Zy46ikNWo2Q8q03BSAUBj+5QHkd70noTxqBzGow4hHC7rwpye/8v/OmNCWdUH4VZXMovdGKJgqmLkdalDog8wA7B1v6ZwONgra1v3dpnyRLVZIr5A5GXjdbbtfV0jL7QlKgZRtWHYrHIN4XfCw/dGkMb9S0rWM3XdenOFmfzjw83/jnaletDtAFRHVkaO+Hd/a6qCSQjtYPz0yudvOYoFi8pFBeC774C02GkE57a7++6RubA2Q== dennisschroeder@me.com" # content of authorized_keys file
      # note: ssh-copy-id will add user@clientmachine after the public key
      # but we can remove the "@clientmachine" part
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDR8FGe66mF5PFKUF3wBXB3hdL1QeY706phvtaC/abJa0xdNq/t/QKuxhbeeya+xYp2MBFsnfwobWtbVgD1fS/UlEJxz+ex0WDdOtqAJ+9iWQLC9JCtcFD0NoMMTPbEulWztdcFrClDSUBm/kMs94a5gIdf8p6gRHMqNzVAzpaxU7pL32rezHp6JtphVdGSbp8ZW2Aq7oHEwcm4R0AeJR75dYcJdu2v+t5g7c9eGm0cqZnWl5KEfqHjyuC+zyPlSGyVDYI3zcKTtUY/0dT9VPhy4+QYt+k8/lY98mvvoWG6Mo3V9gQiJMBNYBn/ktX761LWzUJBh21dLc5KGkoo1Bw7PqyJz0U67fl1ti/ITCsNFWo9M7Nn8fG8beDV2v61C9K4i3oQKep0OocdcdXCIIDde0SQIwQqowWGLs583WiZo6Sy8dnU3u3C7df6Zy46ikNWo2Q8q03BSAUBj+5QHkd70noTxqBzGow4hHC7rwpye/8v/OmNCWdUH4VZXMovdGKJgqmLkdalDog8wA7B1v6ZwONgra1v3dpnyRLVZIr5A5GXjdbbtfV0jL7QlKgZRtWHYrHIN4XfCw/dGkMb9S0rWM3XdenOFmfzjw83/jnaletDtAFRHVkaO+Hd/a6qCSQjtYPz0yudvOYoFi8pFBeC774C02GkE57a7++6RubA2Q== dennisschroeder@me.com" # content of authorized_keys file
    # note: ssh-copy-id will add user@clientmachine after the public key
    # but we can remove the "@clientmachine" part
  ];

  # Enable automatic login for the user.
  services.getty.autologinUser = "dennis";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    wget
    git
    usbutils
  ];

  systemd.services.k3s = {
    description = "K3s";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      K3S_KUBECONFIG_OUTPUT = "/etc/rancher/k3s/k3s.yaml";
      K3S_KUBECONFIG_MODE = "644";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.k3s}/bin/k3s server";
    };
  };


  systemd.services.core = {
    description = "Installs core components into kubernetes";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${coreModule}/bin/core/setup.sh";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 6443 ]; # This is required so that pod can reach the API server (running on port 6443 by default)
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  nix.settings.auto-optimise-store = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
