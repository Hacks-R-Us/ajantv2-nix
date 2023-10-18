{
  stdenv,
  lib,
  cmake,
  ntv2-src,
  buildApps ? true,
}:
stdenv.mkDerivation {
  name = "ntv2";
  src = ntv2-src;
  nativeBuildInputs = [cmake];

  cmakeFlags =
    [
      "-DAJA_BUILD_DRIVER=OFF"
      "-DAJA_BUILD_QT_BASED=OFF"
    ]
    ++ lib.optional (!buildApps) "-DAJA_BUILD_APPS=off";
}
