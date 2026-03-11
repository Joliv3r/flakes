{
  description = "tnoodle as a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        # system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
        sharedLibraries = with pkgs; [
          glib
          libappindicator
        ];
        libPath = pkgs.lib.makeLibraryPath sharedLibraries;
        java = pkgs.openjdk;
        tnoodle = pkgs.fetchurl {
          url = "https://github.com/thewca/tnoodle/releases/latest/download/TNoodle-WCA-1.2.3.jar";
          hash = "sha256-6f9qFk7/7op+zcxcGBEdSqCdHeRxtx3iJIiaEoLZjNU=";
        };
        run-tnoodle = pkgs.writeShellScript "run-tnoodle" ''
          export LD_LIBRARY_PATH=${libPath}:$LD_LIBRARY_PATH
          exec ${java}/bin/java -jar ${tnoodle}
        '';
      in 
      {
        apps.default = {
          type = "app";
          program = "${run-tnoodle}";
        };
      });
}
