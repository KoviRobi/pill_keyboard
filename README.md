# Pill Keyboard

A keyboard written for the bluepill (stm32f103c8t6)

# Building
## Nix
If you have nix, just do `nix-build ./release.nix`. It creates a symlink
`./result` which contains the firmware `pill_keyboard.bin` (also as
`pill_keyboard.hex`, and the elf file `pill_keyboard.elf` should you want to
debug it).

### Why Nix?
I just feel like there is something wrong with using submodules for
dependencies. It might turn out to bite me, but until then I won't have to have
a build of libopencm3 for each of my projects, even if they use a different
microcontroller.

## Manual
- Checkout libopencm3 (see dependencies/libopencm3.nix for exact version)
- Set the environment variable `LIBOPENCM3` to point to the base directory (the
  one containing `lib/`, `include/`)
- Install
- `cd` into `src` and make

# Flashing
- To flash, first ensure you have
  [dapboot](https://github.com/devanlai/dapboot) (see
  bootloader/dapboot-9bb26faefe77da924e947ae9226cd1b0ae593025.patch for a patch
  to make the keyboard start in bootloader mode when you press "B" on plug-in).
  To install the bootloader, do

      cd /path/to/dapboot/checkout
      patch -Np1 < /path/to/pill_keyboard/bootloader/dapboot-9bb26faefe77da924e947ae9226cd1b0ae593025.patch
      make -C src TARGET=BLUEPILL dapboot.hex
      sudo st-flash --format ihex write src/dapboot.hex

  Then you can do

      sudo dfu-util -D ./result/pill_keyboard.hex

  If you want to avoid the bootloader, and flash via e.g.  using st-link and an
  STLink v2 programmer), then change `src/bluepill.ld` to start at
  `0x08000000` instead of `0x08002000`, then

      sudo st-flash --format ihex write ./result/pill_keyboard.hex`
