{ haskellPackages ? (import <nixpkgs> {}).haskellPackages }:
let
  inherit (haskellPackages) cabal cabalInstall_1_18_0_2
    aeson
    conduit
    conduitCombinators
    httpTypes
    network
    scotty
    systemFileio
    systemFilepath
    text
    transformers
    wai
    waiHandlerFastcgi;
in 
  cabal.mkDerivation (self: {
    pname = "cgroups";
    version = "1.0.0";
    src = ./.;
    buildDepends = [
        aeson
        conduit
        conduitCombinators
        httpTypes
        network
        scotty
        systemFileio
        systemFilepath
        text
        transformers
        wai
        waiHandlerFastcgi
    ];
    buildTools = [ cabalInstall_1_18_0_2 ];
    enableSplitObjs = false;
  })
