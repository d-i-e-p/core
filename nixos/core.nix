{ pkgs ? import <nixpkgs> {} }:

let
  manifests = import ./manifests.nix { inherit pkgs; };
  k3s = pkgs.k3s;
in

 pkgs.writeShellApplication {
    name = "diep-core";

    runtimeInputs = [ k3s ];

    text = ''
        k3s kubectl cluster-info
        
        echo "Installing Flux"
        k3s kubectl apply -f "${manifests}/bin/manifests/flux/flux-system/gotk-components.yaml"
        k3s kubectl apply -f "${manifests}/bin/manifests//flux/flux-system/gotk-sync.yaml"

        echo "Installing Core Components"
        k3s kubectl apply -f "${manifests}/bin//manifests/components/config"
    '';
}