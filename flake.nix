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
        src = pkgs.fetchgit {
          url = "https://github.com/arangodb/velocypack.git";
          sha256 = "sha256-NRBOFgcag9R7RTkBUHDqKjsNghUyk/Oq3XVMROsWry4=";
          rev = "772095d3cde89bb00c93e5a06a74ed3b261ad610";
        };
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
      hydraJobs.build = velocypack;
    }
  );
}

