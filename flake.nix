{
  description = "AJA video card software";

  inputs.ntv2-src = {
    type = "github";
    owner = "aja-video";
    repo = "ntv2";
    flake = false;
  };
  inputs.ntv2-gst-src = {
    type = "github";
    owner = "aja-video";
    repo = "ntv2-gst";
    flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ntv2-src,
    ntv2-gst-src,
  }:
  {
    overlays.default = final: prev: {
      ntv2 = final.callPackage ./ntv2 { inherit ntv2-src; };
      ntv2-gst = final.callPackage ./ntv2-gst { inherit ntv2-gst-src; };
      linuxPackages = prev.linuxPackages.extend
      (linuxFinal: linuxPrev: {
        ntv2-driver = linuxFinal.callPackage ./ntv2/driver.nix { inherit ntv2-src; };
      });
    };
  } // flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
  let
    pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
  in {
    packages = {
      inherit (pkgs) ntv2 ntv2-gst;
      inherit (pkgs.linuxPackages) ntv2-driver;
    };
    formatter = pkgs.alejandra;
  });
}
