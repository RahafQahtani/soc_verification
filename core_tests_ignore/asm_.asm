
main.elf:     file format elf32-littleriscv


Disassembly of section .text.startup.main:

00000000 <main>:
   0:	ff010113          	addi	sp,sp,-16
   4:	00112623          	sw	ra,12(sp)
   8:	014000ef          	jal	1c <spi1_toggle_test>
   c:	00c12083          	lw	ra,12(sp)
  10:	00000513          	li	a0,0
  14:	01010113          	addi	sp,sp,16
  18:	00008067          	ret

Disassembly of section .text.spi1_toggle_test:

0000001c <spi1_toggle_test>:
  1c:	200007b7          	lui	a5,0x20000
  20:	ff010113          	addi	sp,sp,-16
  24:	20078023          	sb	zero,512(a5) # 20000200 <spi1_toggle_test+0x200001e4>
  28:	2007c703          	lbu	a4,512(a5)
  2c:	fff00693          	li	a3,-1
  30:	20078793          	addi	a5,a5,512
  34:	0ff77713          	zext.b	a4,a4
  38:	00e107a3          	sb	a4,15(sp)
  3c:	00d78023          	sb	a3,0(a5)
  40:	0007c703          	lbu	a4,0(a5)
  44:	0ff77713          	zext.b	a4,a4
  48:	00e107a3          	sb	a4,15(sp)
  4c:	00078023          	sb	zero,0(a5)
  50:	0007c783          	lbu	a5,0(a5)
  54:	0ff7f793          	zext.b	a5,a5
  58:	00f107a3          	sb	a5,15(sp)
  5c:	01010113          	addi	sp,sp,16
  60:	00008067          	ret
