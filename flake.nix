{
  description = "MSI MEG Coreliquid S360 AIO driver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "coreliquid-driver";
          version = "0.1.0";

          src = ./.;

          buildInputs = [
            pkgs.hidapi
            pkgs.lm_sensors
          ];

          buildPhase = ''
            mkdir -p $out/bin
            gcc -Wall -Wextra -O2 src/my_msi_driver.c -lhidapi-hidraw -lsensors -o $out/bin/my_msi_driver
          '';

          installPhase = ''
            mkdir -p $out/lib/systemd/system
            cp my_msi_driver.service $out/lib/systemd/system/
            cp my_msi_driver-resume.service $out/lib/systemd/system/
          '';

          meta = with pkgs.lib; {
            description = "Linux driver for MSI MEG Coreliquid S360 AIO watercooling";
            license = licenses.mit;
            platforms = platforms.linux;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.gcc
            pkgs.gnumake
            pkgs.hidapi
            pkgs.lm_sensors
            pkgs.pkg-config
          ];

          shellHook = ''
            echo "coreliquid_driver development environment"
            echo "Run 'make' to build"
          '';
        };
      }
    );
}
