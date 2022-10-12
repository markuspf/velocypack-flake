{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-22.05";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      velocypack = (with pkgs; stdenv.mkDerivation {
        meta = {
          homepage = "https://github.com/arangodb/velocypack";
        };
        pname = "velocypack";
        version = "git";
        src = ./.;
        nativeBuildInputs = [
          clang
          cmake
        ];
        buildPhase = "make -j $NIX_BUILD_CORES";
        installPhase = ''
          make install
        '';
      });
    in rec {
      devShell = pkgs.mkShell {
        buildInputs = [ velocypack ];
      };
      packages.default = velocypack;
    }
  );
}

