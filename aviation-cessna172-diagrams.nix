{ mkDerivation, aviation-cessna172-weight-balance, aviation-units
, aviation-weight-balance, base, colour, diagrams-cairo
, diagrams-core, diagrams-lib, lens, mtl, plots, stdenv
}:
mkDerivation {
  pname = "aviation-cessna172-diagrams";
  version = "0.0.2";
  src = ./.;
  libraryHaskellDepends = [
    aviation-cessna172-weight-balance aviation-units
    aviation-weight-balance base colour diagrams-cairo diagrams-core
    diagrams-lib lens mtl plots
  ];
  homepage = "https://github.com/data61/aviation-cessna172-diagrams";
  description = "Diagrams for the Cessna 172 aircraft in aviation";
  license = "unknown";
}
