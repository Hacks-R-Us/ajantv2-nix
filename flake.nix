{
  description = "AJA video card software";
  inputs.ntv2-src = {
    type = "github";
    owner = "aja-video";
    repo = "ntv2";
    flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ntv2-src,
  }:
    (
      flake-utils.lib.eachSystem ["x86_64-linux"] (system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        packages.aja-ntv2-gst = pkgs.callPackage ./ntv2-gst.nix {
          ajantv2 = pkgs.callPackage ./aja-ntv2/default.nix {
            inherit ntv2-src;
            buildApps = false;
          };
        };
      })
    )
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      formatter = pkgs.alejandra;
    })
    // {
      overlays.default = final: prev: {
        ajantv-utils = final.callPackage ./aja-ntv2/default.nix { inherit ntv2-src; };
        ajantv-driver = final.linuxPackages.callPackage ./aja-ntv2/driver.nix { inherit ntv2-src; };
        aja-ntv2-gst = self.packages.${prev.system}.aja-ntv2-gst;
      };
    };
}
