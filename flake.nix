{
  description = "Master flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    tnoodle.url = "path:./programs/tnoodle/";
    # tnoodle.inputs.flake-parts.follows = "flake-parts";
  };

  outputs = { self, tnoodle, flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { inputs', ... }: {
        apps = {
          tnoodle = inputs'.tnoodle.apps.tnoodle;
        };
      };

    };
}
