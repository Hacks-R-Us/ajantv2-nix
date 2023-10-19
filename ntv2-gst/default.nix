{
  stdenv,
  ntv2-gst-src,
  autoconf,
  automake,
  pkg-config,
  libtool,
  gst_all_1,
  ntv2,
}:
stdenv.mkDerivation {
  name = "ntv2-gst";
  src = ntv2-gst-src;
  sourceRoot = "source/gst-plugin";
  patches = [./no.patch];

  nativeBuildInputs = [autoconf automake pkg-config libtool gst_all_1.gst-plugins-base ntv2];
  GST_NTV2 = "${ntv2}/include";
  preConfigure = ''
    ./autogen.sh
  '';
}
