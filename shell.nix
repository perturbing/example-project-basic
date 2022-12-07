{ pkgs ? import <nixpkgs> {
    overlays = [ (import (fetchTarball "https://github.com/input-output-hk/iohk-nix/tarball/e936cc0972fceb544dd7847e39fbcace1c9c00de" + "/overlays/crypto/")) ];
  } 
}:

let newSecp256k1 = pkgs.secp256k1.overrideAttrs (old: {
	    src = pkgs.fetchFromGitHub {
		    owner = "bitcoin-core";
 		    repo = "secp256k1";
		    rev = "ac83be33d0956faf6b7f61a60ab524ef7d6a473a";
		    sha256 = "11zbgdkfh93lzhd7kisgxnqzcn2k2ryrl9c07ihqdllh83f5any6";
		  };
    });

    cardano-node = import (
      pkgs.fetchFromGitHub {
        owner = "input-output-hk";
        repo = "cardano-node";
        rev = "1.35.3";
        sha256 = "020fwimsm24yblr1fmnwx240wj8r3x715p89cpjgnnd8axwf32p0";
      }
    ) {};

in
  pkgs.mkShell {
    nativeBuildInputs = [ 
                    newSecp256k1 
                    cardano-node.cardano-node
                    cardano-node.cardano-cli
                    pkgs.libsodium-vrf 
                    pkgs.zlib
                    pkgs.lzma
                    pkgs.glibcLocales
		    pkgs.pkg-config
                    pkgs.gmp
		    pkgs.postgresql
    ];
}
