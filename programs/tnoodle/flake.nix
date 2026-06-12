{
  description = "tnoodle as a flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      sharedLibraries = with pkgs; [ glib libappindicator ];
      libPath = pkgs.lib.makeLibraryPath sharedLibraries;
      java = pkgs.openjdk;
      tnoodle-jar = pkgs.fetchurl {
        url = "https://github.com/thewca/tnoodle/releases/latest/download/TNoodle-WCA-1.2.3.jar";
        hash = "sha256-6f9qFk7/7op+zcxcGBEdSqCdHeRxtx3iJIiaEoLZjNU=";
      };
      tnoodle = pkgs.writeShellApplication {
        name = "tnoodle";
        runtimeInputs = [ java ];
        text = ''
          export LD_LIBRARY_PATH=${libPath}:''${LD_LIBRARY_PATH:-}
          exec java -jar "${tnoodle-jar}" "$@"
        '';
      };
    in {
      packages.${system}.default = tnoodle;

      apps.${system}.default = {
        type = "app";
        program = "${tnoodle}/bin/tnoodle";  # must point to the binary, not the package dir
      };
    };
}
