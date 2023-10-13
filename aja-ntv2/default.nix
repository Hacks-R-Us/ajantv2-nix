{
  stdenv,
  callPackage,
  lib,
  cmake,
  buildApps ? true,
}:
stdenv.mkDerivation {
  name = "ajantv2-dev";
  src = callPackage ./src.nix {};
  nativeBuildInputs = [ cmake ];

  cmakeFlags =
    [
      "-DAJA_BUILD_DRIVER=OFF"
      "-DAJA_BUILD_QT_BASED=OFF"
    ]
    ++ lib.optional (!buildApps) "-DAJA_BUILD_APPS=off";
}
