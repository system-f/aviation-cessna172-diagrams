{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
                       then pkgs.haskell.packages.ghc7103
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
      rev = "aee9b5c37946acfa28dc8ce96bf71643e01f28c7";
      sha256 = "0kyqn2mn5yvjngqzapqgidvpj5r664i5afkbj0di0hp2nj7f58ac";
    };

    aviation-weight-balance = pkgs.fetchFromGitHub {
      owner = "data61";
      repo = "aviation-weight-balance";
      rev = "00c65b36ff350b6577bf0f815bd902f820a4bbf0";
      sha256 = "0sxz247qwjmmkpwjc5221jsph3vbcpgjf93sdcqnnk7r8hlbxj9h";
    };

    aviation-cessna172-weight-balance = pkgs.fetchFromGitHub {
      owner = "data61";
      repo = "aviation-cessna172-weight-balance";
      rev = "69b0ed0817f2971f0feca730fbdb5ea08da90f40";
      sha256 = "0mqfqqx6h5g9fmgyg8dhjf6f6vw1w7am2y4f9mz8r55ls026faf2";
    };

    intervals = pkgs.fetchFromGitHub {
      owner = "ekmett";
      repo = "intervals";
      rev = "5307fb058cd6135101612ea7e3be7cf56be2c583";
      sha256 = "16d7b3xans494lgyvjz42gljpjr49r01nm45kl74p3spsp1pv9kv";
    };

    hgeometry = pkgs.fetchFromGitHub {
      owner = "noinia";
      repo = "hgeometry";
      rev = "0.6.0.0";
      sha256 = "00s3hckx04qbywwbh85rq16z3cg2ik6z7vdl9xnkb233lpsczbma";
    };

    vinyl = pkgs.fetchFromGitHub {
      owner = "VinylRecords";
      repo = "vinyl";
      rev = "616e72746f3295db28303b29fe027b4144479070";
      sha256 = "0zm2bsjrgiifggar3w3c6w8hhpkb9rkfqyg4zz3qb5i9d1dd9a36";
    };

  };

  modifiedHaskellPackages = haskellPackages.override {
    overrides = self: super: import sources.papa self // {
      aviation-units = import sources.aviation-units {};
      aviation-weight-balance = import sources.aviation-weight-balance {};
      aviation-cessna172-weight-balance = import sources.aviation-cessna172-weight-balance {};
      parsers = pkgs.haskell.lib.dontCheck super.parsers;        
      intervals = super.callCabal2nix "intervals" "${sources.intervals}" {};
      hgeometry = pkgs.haskell.lib.dontCheck (super.callCabal2nix "hgeometry" "${sources.hgeometry}" {});
      vinyl = super.callCabal2nix "vinyl" "${sources.vinyl}" {};
      Frames = self.callHackage "Frames" "0.1.9" {};
      singletons = pkgs.haskell.lib.dontCheck (self.callHackage "singletons" "2.1" {});
      th-desugar = self.callHackage "th-desugar" "1.6" {};
      fixed-vector = self.callHackage "fixed-vector" "0.9.0.0" {};
      semigroupoids = pkgs.haskell.lib.dontCheck (self.callHackage "semigroupoids" "5.2" {});
      linear = pkgs.haskell.lib.dontCheck (self.callHackage "linear" "1.20.6" {});
      diagrams-lib = pkgs.haskell.lib.dontCheck super.diagrams-lib;
    };
  };

  aviation-cessna172-diagrams = modifiedHaskellPackages.callPackage ./aviation-cessna172-diagrams.nix {};

in

  aviation-cessna172-diagrams

