{ stdenv
, lib
, libopencm3
, gcc-arm-embedded
, Literate
, cppcheck
, pandoc
, stlink
, dfu-util
}:

stdenv.mkDerivation {
  name = "pill_keyboard";
  src = ./src;

  nativeBuildInputs = [ stlink dfu-util ];
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
}
