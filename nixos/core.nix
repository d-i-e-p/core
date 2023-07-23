{ lib, pkgs ? import <nixpkgs> {} }:

 pkgs.stdenv.mkDerivation rec {
    name = "core";
    src = pkgs.fetchFromGitHub {
        owner = "d-i-e-p";
        repo = "core";
        rev = "main";
        sha256 = "sha256-KmM0ZZLXbaWg1fPqp6/lDYsCwcARCBmiwlulmC9yxao=";
    };

    phases = "buildPhase";
    builder = ./setup.sh;

    nativeBuildInputs = [ pkgs.k3s ];
    PATH = lib.makeBinPath nativeBuildInputs;

    installPhase = ''
        mkdir -p $out/bin
        cp -r $src $out/bin/core
        ls $out/bin
        # Set the permissions of the downloaded .sh file to make it executable
        chmod +x $out/bin/core/setup.sh
    '';
}