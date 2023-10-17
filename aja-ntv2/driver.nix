{
  stdenv,
  nukeReferences,
  kernel,
  ntv2-src,
}:
stdenv.mkDerivation {
  name = "ajantv2-driver-${kernel.version}";
  src = ntv2-src;
  patches = [./lol.patch ./newkernels.patch];
  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [nukeReferences];

  # the makefile symlinks some files, which can't be done at build time, so do it here
  # and patch out the offending bits of makefile (lol.patch)
  postUnpack = ''
    cp source/ajalibraries/ajantv2/src/ntv2devicefeatures.cpp source/ajadriver/linux/ntv2devicefeatures.c
    cp source/ajalibraries/ajantv2/src/ntv2driverprocamp.cpp source/ajadriver/linux/ntv2driverprocamp.c
    cp source/ajalibraries/ajantv2/src/ntv2vpidfromspec.cpp source/ajadriver/linux/ntv2vpidfromspec.c
  '';
  # AJA_CREATE_DEVICE_NODES causes the driver to automatically create /dev nodes rather
  # than need to use the weird load_ajantv2 script
  makeFlags = [
    "AJA_CREATE_DEVICE_NODES=1"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "--directory=ajadriver/linux"
  ];
  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/misc
    for x in $(find . -name '*.ko'); do
      nuke-refs $x
      cp $x $out/lib/modules/${kernel.modDirVersion}/misc/
    done
  '';
}
