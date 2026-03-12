{
  description = "tnoodle as a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      apps = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
        sharedLibraries = with pkgs; [
          glib
          libappindicator
        ];
        libPath = pkgs.lib.makeLibraryPath sharedLibraries;
        java = pkgs.openjdk;
        tnoodle-jar = pkgs.fetchurl {
          url = "https://github.com/thewca/tnoodle/releases/latest/download/TNoodle-WCA-1.2.3.jar";
          hash = "sha256-6f9qFk7/7op+zcxcGBEdSqCdHeRxtx3iJIiaEoLZjNU=";
        };
        tnoodle = pkgs.writeShellScript "tnoodle" ''
          export LD_LIBRARY_PATH=${libPath}:$LD_LIBRARY_PATH
          exec ${java}/bin/java -jar ${tnoodle-jar}
        '';
      in {
        tnoodle = {
          type = "app";
          program = "${tnoodle}";
        };
      });
    };
}

