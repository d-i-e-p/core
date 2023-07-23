{ pkgs ? import <nixpkgs> {} }:

let
  fetchFromGitHub = pkgs.fetchFromGitHub;
in pkgs.stdenv.mkDerivation {
  name = "core";
  src = fetchFromGitHub {
    owner = "d-i-e-p";
    repo = "core";
    rev = "main";
  };
  
  buildInputs = [ pkgs.k3s ];
  
  installPhase = ''
    # Set the permissions of the downloaded .sh file to make it executable
    chmod +x $src/setup.sh
  '';
}
