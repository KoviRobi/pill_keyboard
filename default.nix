{ stdenv
, lib
, libopencm3
, gnumake # TODO: only because of the info page
, gcc-arm-embedded
, Literate
, cppcheck
, pandoc
, stlink
, dfu-util
}:

stdenv.mkDerivation rec {
  name = "pill_keyboard";
  src = ./src;

  nativeBuildInputs = [ gnumake stlink dfu-util ];
  buildInputs = [
    cppcheck
    pandoc
    Literate gcc-arm-embedded
  ];

  LIBOPENCM3 = libopencm3;
  LIBOPENCM3DOC = libopencm3.doc;

  meta = with lib; {
    description = "Firmware for a bluepill based keyboard";
    maintainers = with maintainers; [ kovirobi ];
    license = licenses.mit;
  };

  shellHook = let
    inputs = stdenv.defaultBuildInputs ++ stdenv.defaultNativeBuildInputs ++
             buildInputs ++ nativeBuildInputs;
    infoDrvs = builtins.filter (drvP: lib.isDerivation drvP) inputs;
    infoOutputs = map (drv: lib.getOutput "info" drv) infoDrvs;
    infoPaths = map (drv: "${drv}/share/info") infoOutputs;
    #extantInfoPaths = builtins.filter (p: builtins.pathExists (builtins.toPath p)) infoPaths;
  in ''
    INFOPATH=${lib.concatStringsSep ":" infoPaths}''${INFOPATH:+:}$INFOPATH
  '';
}
