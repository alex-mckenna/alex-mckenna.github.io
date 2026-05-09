{
  description = "My personal blog";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages = {
      default = pkgs.stdenvNoCC.mkDerivation {
        name = "partially-applied.com";
        version = "2026-05-09";
        src = self;

        nativeBuildInputs = [
          pkgs.zola
        ];

        buildPhase = ''
          zola build
        '';

        installPhase = ''
          cp -r public $out
        '';
      };
    };

    devShells = {
      default = pkgs.mkShell {
        packages = [
          pkgs.zola
        ];
      };
    };
  });
}
