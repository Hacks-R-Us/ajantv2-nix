{
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  pkgconfig,
  libtool,
  gst_all_1,
  ajantv2,
}:
stdenv.mkDerivation {
  name = "aja-ntv2-gst";
  src = fetchFromGitHub {
    owner = "aja-video";
    repo = "ntv2-gst";
    rev = "refs/heads/master";
    hash = "sha256-90TdrsnO5LatLD4dwivOnZG4tGJmNs2tdAsrL7eQF8g=";
  };
  sourceRoot = "source/gst-plugin";
  patches = [./no.patch];

  nativeBuildInputs = [autoconf automake pkgconfig libtool gst_all_1.gst-plugins-base ajantv2];
  GST_NTV2 = "${ajantv2}/include";
  preConfigure = ''
    ./autogen.sh
  '';
}
