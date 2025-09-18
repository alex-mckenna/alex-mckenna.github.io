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
        src = self;

        buildPhase = ''
          ${pkgs.hugo}/bin/hugo
          ${pkgs.prettier}/bin/prettier -w public '!**/*.{css,js}'
        '';

        nativeBuildInputs = [
          pkgs.tailwindcss_4
        ];

        installPhase = ''
          cp -r public $out
        '';
      };
    };

    devShells = {
      default = pkgs.mkShell {
        buildInputs = [
          pkgs.hugo
          pkgs.prettier
          pkgs.tailwindcss_4
        ];
      };
    };
  });
}
