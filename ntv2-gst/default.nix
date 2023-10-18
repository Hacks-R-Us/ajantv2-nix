{
  stdenv,
  ntv2-gst-src,
  autoconf,
  automake,
  pkgconfig,
  libtool,
  gst_all_1,
  ntv2,
}:
stdenv.mkDerivation {
  name = "ntv2-gst";
  src = ntv2-gst-src;
  sourceRoot = "source/gst-plugin";
  patches = [./no.patch];

  nativeBuildInputs = [autoconf automake pkgconfig libtool gst_all_1.gst-plugins-base ntv2];
  GST_NTV2 = "${ntv2}/include";
  preConfigure = ''
    ./autogen.sh
  '';
}
