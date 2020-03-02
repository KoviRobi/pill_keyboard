PREFIX=arm-none-eabi-
CC=$(PREFIX)gcc
OBJCOPY=$(PREFIX)objcopy

BUILDDIR=../build
DOCDIR=../docs
VERSION ?= $(shell git describe --always --tags --dirty)
FOUR_BYTE_HASH ?= $(shell echo -n 0x; git describe --always --abbrev=4)

.PHONY: all doc clean

all: keyboard.bin

keyboard.elf: $(addprefix $(BUILDDIR)/,\
	main.o \
	)

ARCHFLAGS += -mcpu=cortex-m3 -mthumb -mno-thumb-interwork -mfpu=vfp -msoft-float -mfix-cortex-m3-ldrd
CFLAGS += $(ARCHFLAGS) \
          -DSTM32F1 -I$(LIBOPENCM3)/include \
          -DVERSION=$(VERSION) -DFOUR_BYTE_HASH=$(FOUR_BYTE_HASH)
LDFLAGS += $(ARCHFLAGS) \
           -L$(LIBOPENCM3)/lib -lopencm3_stm32f1 \
           --specs=nosys.specs \
           -nostartfiles \
           -Wl,-T,bluepill.ld \
           -Wl,-gc-sections \
           -mtune=cortex-m3 -mthumb


$(BUILDDIR)/%.c $(BUILDDIR)/%.h: %.lit
	-test -d $(BUILDDIR) || mkdir $(BUILDDIR)
	lit --out-dir $(BUILDDIR) -t $<

%.d: %.c
	$(CC) $< $(CFLAGS) -MM -o $@

%.elf %.map:
	$(CC) $+ -Wl,-Map=$*.map $(LDFLAGS) -o $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

# DOC
doc: index.lit
	-test -d $(DOCDIR) || mkdir $(DOCDIR)
	lit --out-dir $(DOCDIR) -w $<
	mv $(DOCDIR)/_book/* $(DOCDIR)
	rmdir $(DOCDIR)/_book
	mv $(DOCDIR)/*_contents.html $(DOCDIR)/index.html

clean:
	-rm -r $(BUILDDIR)
