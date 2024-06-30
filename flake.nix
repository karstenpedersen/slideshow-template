{
  description = "Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            flake-checker.enable = true;
            end-of-file-fixer.enable = true;
            trim-trailing-whitespace.enable = true;
          };
        };
      });

      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.writeShellScriptBin "cowsay-moo" ''
            ${pkgs.cowsay}/bin/cowsay moo
          '';
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = (with pkgs; [
              slides
              just
              inotify-tools
              graph-easy
              plantuml
            ]) ++ self.checks.${system}.pre-commit-check.enabledPackages;
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
        });
    };
}
