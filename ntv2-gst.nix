{
  stdenv,
  ntv2-gst-src,
  autoconf,
  automake,
  pkgconfig,
  libtool,
  gst_all_1,
  ajantv2,
}:
stdenv.mkDerivation {
  name = "aja-ntv2-gst";
  src = ntv2-gst-src;
  sourceRoot = "source/gst-plugin";
  patches = [./no.patch];

  nativeBuildInputs = [autoconf automake pkgconfig libtool gst_all_1.gst-plugins-base ajantv2];
  GST_NTV2 = "${ajantv2}/include";
  preConfigure = ''
    ./autogen.sh
  '';
}
