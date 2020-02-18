{ nixpkgs ? import <nixpkgs> {}
}:
let
  callPackage = nixpkgs.lib.callPackageWith (nixpkgs // deps);

  depsDir = builtins.readDir ./.;
  foldAttrs = op: nul: attrs: builtins.foldl' (nul: name: op nul name attrs.${name})
                                     nul
                                     (builtins.attrNames attrs);
  deps = foldAttrs (nul: name: value:
    if name == "default.nix" then nul else
      ({ ${if value == "directory"
           then name else
           builtins.replaceStrings [ ".nix" ] [ "" ] name} =
        callPackage (./. + ("/" + name)) {}; } // nul))
    {}
    (builtins.readDir ./.);
in
  deps // { inherit callPackage; }
