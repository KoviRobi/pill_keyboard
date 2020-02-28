MEMORY
{
  /* The bootloader occupies the first 0x2000/8K */
	rom (rx)  : ORIGIN = 0x08002000, LENGTH = 64K-8K
	ram (rwx) : ORIGIN = 0x20000000, LENGTH = 20K
}

/* Include the common ld script. */
INCLUDE cortex-m-generic.ld

