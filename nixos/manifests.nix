{ pkgs ? import <nixpkgs> {} }:

let
  fetchFromGitHub = pkgs.fetchFromGitHub;
in
pkgs.stdenv.mkDerivation {
    name = "manifests";

    # The src attribute fetches your project from GitHub
    src = fetchFromGitHub {
        owner = "d-i-e-p";
        repo = "core";
        rev = "fc01797";
        sha256 = "sha256-LrtluI9YVLCsXp+eCO6LaWCqCr7tQ+7AwWaAiDhDj3A=";
    };

    installPhase = ''
        echo "Installing manifest files..."
        mkdir -p $out/bin
        cp -r $src $out/bin/manifests
        
        echo "Installed these manifest files to $out"
        ls -la $out
        echo "Done installing manifest files!"
    '';
}
