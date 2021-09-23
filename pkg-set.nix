{ sources ? import ./nix/sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import sources.nixpkgs haskellNix.nixpkgsArgs
, compiler-nix-name ? "ghc8107"
, modules ? [{
    packages.wai-app-static.components.exes.warp.configureFlags = [
      "--ghc-option=-optl=-static"
      "--ghc-option=-threaded"
      "--ghc-option=-rtsopts"
      "--ghc-option=-with-rtsopts=--nonmoving-gc"
    ];
  }]
}:
pkgs.pkgsCross.musl64.callPackage
  ({ haskell-nix }:
    haskell-nix.cabalProject {
      src = haskell-nix.haskellLib.cleanGit {
        name = "haskell-nix-static-linking-src";
        src = ./.;
      };
      inherit compiler-nix-name modules;
    })
{ }
