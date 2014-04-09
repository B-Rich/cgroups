{ haskellPackages ? (import <nixpkgs> {}).haskellPackages }:
let
  inherit (haskellPackages) cabal cabalInstall_1_18_0_2
    conduit conduitCombinators systemFileio systemFilepath
    wai waiHandlerFastcgi
    aeson scotty text transformers; # Haskell dependencies here

in cabal.mkDerivation (self: {
  pname = "cgroups";
  version = "1.0.0";
  src = ./.;
  buildDepends = [
    # As imported above
    conduit conduitCombinators systemFileio systemFilepath
    wai waiHandlerFastcgi
    aeson scotty text transformers
  ];
  buildTools = [ cabalInstall_1_18_0_2 ];
  enableSplitObjs = false;
})

