{ lib, pkgs ? import <nixpkgs> {} }:

 pkgs.stdenv.mkDerivation rec {
    name = "core";
    src = pkgs.fetchFromGitHub {
        owner = "d-i-e-p";
        repo = "core";
        rev = "main";
        sha256 = "";
    };

    buildInputs = [ pkgs.k3s ];

    installPhase = ''
        mkdir -p $out/bin
        cp -r $src $out/bin/core
        ls $out/bin/core
        # Set the permissions of the downloaded .sh file to make it executable
        chmod +x $out/bin/core/setup.sh
    '';
}