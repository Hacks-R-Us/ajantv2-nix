{
  description = "AJA video card software";
  inputs.aja-ntv2 = {
    url = "github:aja-video/ntv2";
    flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    aja-ntv2,
  }:
    (
      flake-utils.lib.eachSystem ["x86_64-linux"] (system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        packages.aja-ntv2-gst = pkgs.callPackage ./ntv2-gst.nix {
          ajantv2 = pkgs.callPackage ./aja-ntv2/default.nix {
            aja-src = aja-ntv2;
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
        ajantv-utils = final.callPackage ./aja-ntv2/default.nix {aja-src = aja-ntv2;};
        ajantv-driver = final.linuxPackages.callPackage ./aja-ntv2/driver.nix {aja-src = aja-ntv2;};
        aja-ntv2-gst = self.packages.${prev.system}.aja-ntv2-gst;
      };
    };
}
