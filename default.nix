{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  sources = {
    papa = pkgs.fetchFromGitHub {
      owner = "qfpl";
      repo = "papa";
      rev = "97ef00aa45c70213a4f0ce348a2208e3f482a7e3";
      sha256 = "0qm0ay49wc0frxs6ipc10xyjj654b0wgk0b1hzm79qdlfp2yq0n5";
    };

    aviation-units = pkgs.fetchFromGitHub {
      owner = "data61";
      repo = "aviation-units";
      rev = "c67a8ed7af0218316a308abbbfa804b896319956";
      sha256 = "0jhhc4q2p7kg07bl7hk0571rp8k5qg02mgnfy0cm51hj5fd2lihx";
    };

    aviation-weight-balance = pkgs.fetchFromGitHub {
      owner = "data61";
      repo = "aviation-weight-balance";
      rev = "04f2d82df78d3981539470988124bdfe5454884c";
      sha256 = "1s2ncg4k07i9wriq7qr5vjzmagyzjz1mcscwdi99f450bvmlc8nh";
    };

    aviation-cessna172-weight-balance = pkgs.fetchFromGitHub {
      owner = "data61";
      repo = "aviation-cessna172-weight-balance";
      rev = "2cecf44cec04f23a88c088ef2451d334c30c4fb0";
      sha256 = "1if7sjgz0cjwypiawaya2r1skx3rcq5a99k31ka52g4m9x4kib0j";
    };

  };

  modifiedHaskellPackages = haskellPackages.override {
    overrides = self: super: import sources.papa self // {
      aviation-units = import sources.aviation-units {};
      aviation-weight-balance = import sources.aviation-weight-balance {};
      aviation-cessna172-weight-balance = import sources.aviation-cessna172-weight-balance {};
      parsers = pkgs.haskell.lib.dontCheck super.parsers;        
    };
  };

  aviation-cessna172-diagrams = modifiedHaskellPackages.callPackage ./aviation-cessna172-diagrams.nix {};

in

  aviation-cessna172-diagrams

