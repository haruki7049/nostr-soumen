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
        { pkgs, lib, ... }:
        let
          buildInputs.dependencies = [
            pkgs.cli11
            pkgs.ftxui
          ];
          buildInputs.dev-dependencies = [ ];
          nativeBuildInputs.lsp = [
            pkgs.nil # Nix
            pkgs.clang-tools # C / C++
            pkgs.ruff # Python (Scons)
          ];
          nativeBuildInputs.build = [
            pkgs.scons
            pkgs.pkg-config
          ];

          nostr-soumen = pkgs.stdenv.mkDerivation {
            name = "nostr-soumen";
            src = lib.cleanSource ./.;
            doCheck = true;

            nativeBuildInputs = nativeBuildInputs.build;
            buildInputs = buildInputs.dependencies;
          };
        in
        {
          treefmt = {
            projectRootFile = ".git/config";

            # Nix
            programs.nixfmt.enable = true;

            # C / C++
            programs.clang-format.enable = true;

            # Python
            programs.ruff-check.enable = true;
            programs.ruff-format.enable = true;

            # GitHub Actions
            programs.actionlint.enable = true;

            # Markdown
            programs.mdformat.enable = true;

            # ShellScript
            programs.shellcheck.enable = true;
            programs.shfmt.enable = true;
          };

          packages = {
            inherit nostr-soumen;
            default = nostr-soumen;
          };

          checks = {
            inherit nostr-soumen;
          };

          devShells.default = pkgs.mkShell {
            nativeBuildInputs = nativeBuildInputs.lsp ++ nativeBuildInputs.build;
            buildInputs = buildInputs.dependencies;
          };
        };
    };
}
