{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # The flake-compat input to use shell.nix and default.nix on root directory
    flake-compat.url = "github:edolstra/flake-compat";

    # Formatter by treefmt-nix
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        { pkgs, ... }:
        let
          tools.lsp = [
            pkgs.nil # Nix
            pkgs.clang-tools # C / C++
            pkgs.ruff # Python (Scons)
          ];
          tools.build = [
            pkgs.scons
            pkgs.pkg-config
          ];
          buildInputs = [
            pkgs.cli11
            pkgs.ftxui
          ];
        in
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = tools.lsp ++ tools.build;
            inherit buildInputs;
          };
        };
    };
}
