{ sources ? import ./nix/sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import sources.nixpkgs haskellNix.nixpkgsArgs
, name ? "wai-app-static"
, exe ? "warp"
, version ? "latest"
, revision ? "default"
, compiler-nix-name ? "ghc8107"
, modules ? [
    { configureFlags = [ "-O2" ]; }
    { dontStrip = false; }
    {
      packages."${name}".components.exes."${exe}".configureFlags = [
        "--ghc-option=-optl-static"
        "--ghc-option=-threaded"
        "--ghc-option=-rtsopts"
        "--ghc-option=-with-rtsopts=--nonmoving-gc"
        "--ghc-option=-with-rtsopts=-N"
      ];
    }
  ]
}:
pkgs.pkgsCross.musl64.callPackage
  ({ haskell-nix }:
    (haskell-nix.hackage-package {
      inherit name version revision compiler-nix-name modules;
    }).components.exes."${exe}")
{ }
