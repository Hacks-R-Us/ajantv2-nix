{
  description = "AJA video card software";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: (
    flake-utils.lib.eachSystem ["x86_64-linux"] (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages.aja-ntv2-gst = pkgs.callPackage ./ntv2-gst.nix { 
        ajantv2 = pkgs.callPackage ./aja-ntv2/default.nix { buildApps = false; };
      };
      formatter = pkgs.alejandra;
    })
    ) // {
      overlays.default = (final: prev: {
        ajantv-utils = final.callPackage ./aja-ntv2/default.nix {};
        ajantv-driver = final.linuxPackages.callPackage ./aja-ntv2/driver.nix {};
        aja-ntv2-gst = self.packages.${prev.system}.aja-ntv2-gst;
      });
    };
}
