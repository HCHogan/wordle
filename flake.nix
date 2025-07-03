{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        hPkgs = pkgs.haskell.packages.ghc912;
        name = "wordle";
        src = ./.;
      in {
        packages.default = hPkgs.callCabal2nix name src {};

        devShells.default = hPkgs.shellFor {
          packages = p: [self.packages.${system}.default];
          nativeBuildInputs = with pkgs; [
            haskell.packages.ghc912.haskell-language-server

            cabal-install
            hlint
            fourmolu
            alex
            happy

            haskellPackages.fast-tags
            haskellPackages.hoogle
            haskellPackages.ghci-dap
            haskellPackages.haskell-debug-adapter
            haskellPackages.cabal-fmt
          ];
        };
      }
    );
}
