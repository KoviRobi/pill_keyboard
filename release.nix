{ nixpkgs ? import <nixpkgs> {}
}:
let deps = import ./dependencies { inherit nixpkgs; };
in deps.callPackage ./. {}
