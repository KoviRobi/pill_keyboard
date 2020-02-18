{ stdenv
, fetchFromGitHub
, gcc-arm-embedded
, python3
, targets ? [ "stm32/f0" "stm32/f1" "stm32/f2" "stm32/f3" "stm32/f4" "stm32/f7"
		"stm32/l0" "stm32/l1" "stm32/l4"
		"stm32/g0"
		"stm32/h7"
		"gd32/f1x0"
		"lpc13xx" "lpc17xx" "lpc43xx/m4" "lpc43xx/m0"
		"lm3s" "lm4f" "msp432/e4"
		"efm32/tg" "efm32/g" "efm32/lg" "efm32/gg" "efm32/hg" "efm32/wg"
		"efm32/ezr32wg"
		"sam/3a" "sam/3n" "sam/3s" "sam/3u" "sam/3x" "sam/4l"
		"sam/d"
		"vf6xx"
		"swm050"
		"pac55xx" ]
, doxygen
, graphviz
}:

stdenv.mkDerivation rec {
  pname = "libopencm3";
  version = "unstable-2020-01-29";

  outputs = [ "out" "doc" ];

  postPatch = ''
    patchShebangs scripts
  '';

  src = fetchFromGitHub {
    owner = "libopencm3";
    repo = "libopencm3";
    rev = "4b3d58339436596768303f24d87a53291e27dc1f";
    sha256 = "10p97sk78hp247abdcybahn7z6igx7ms5y27wzrzk4pfcs3bx9vq";
  };

  buildFlags = [ "build" "doc" ];

  TARGETS = targets;

  dontFixup = true;

  installPhase = ''
    mkdir -p $out
    cp -r lib $out/
    cp -r include $out/
    cp -r ld $out/
    mkdir -p $doc/share
    cp -r doc $doc/share
  '';

  nativeBuildInputs = [ gcc-arm-embedded python3 doxygen graphviz ];
}
