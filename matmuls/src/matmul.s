	.arch armv8.5-a
	.build_version macos,  14, 0
	.text
	.cstring
	.align	3
lC0:
	.ascii "Shape mismatch!\0"
	.align	3
lC1:
	.ascii "Realloc failed!\0"
	.text
	.align	2
	.globl _matmul
_matmul:
LFB10:
	stp	x29, x30, [sp, -80]!
LCFI0:
	mov	x29, sp
LCFI1:
	str	x0, [x29, 40]
	str	x1, [x29, 32]
	str	x2, [x29, 24]
	ldr	x0, [x29, 40]
	ldr	w1, [x0, 4]
	ldr	x0, [x29, 32]
	ldr	w0, [x0]
	cmp	w1, w0
	beq	L2
	adrp	x0, lC0@PAGE
	add	x0, x0, lC0@PAGEOFF;
	bl	_printf
	b	L1
L2:
	ldr	x0, [x29, 40]
	ldr	w1, [x0]
	ldr	x0, [x29, 24]
	str	w1, [x0]
	ldr	x0, [x29, 32]
	ldr	w1, [x0, 4]
	ldr	x0, [x29, 24]
	str	w1, [x0, 4]
	ldr	x0, [x29, 24]
	ldr	x2, [x0, 8]
	ldr	x0, [x29, 24]
	ldr	w0, [x0]
	sxtw	x1, w0
	ldr	x0, [x29, 24]
	ldr	w0, [x0, 4]
	sxtw	x0, w0
	mul	x0, x1, x0
	lsl	x0, x0, 2
	mov	x1, x0
	mov	x0, x2
	bl	_realloc
	str	x0, [x29, 56]
	ldr	x0, [x29, 56]
	cmp	x0, 0
	bne	L4
	adrp	x0, lC1@PAGE
	add	x0, x0, lC1@PAGEOFF;
	bl	_printf
	b	L1
L4:
	ldr	x0, [x29, 24]
	ldr	x1, [x29, 56]
	str	x1, [x0, 8]
	ldr	x0, [x29, 24]
	ldr	x4, [x0, 8]
	ldr	x0, [x29, 24]
	ldr	w0, [x0, 4]
	sxtw	x1, w0
	ldr	x0, [x29, 24]
	ldr	w0, [x0]
	sxtw	x0, w0
	mul	x0, x1, x0
	lsl	x0, x0, 2
	mov	x1, -1
	mov	x3, x1
	mov	x2, x0
	mov	w1, 0
	mov	x0, x4
	bl	___memset_chk
	str	wzr, [x29, 76]
	b	L5
L10:
	str	wzr, [x29, 72]
	b	L6
L9:
	ldr	x0, [x29, 40]
	ldr	x1, [x0, 8]
	ldr	x0, [x29, 40]
	ldr	w2, [x0, 4]
	ldr	w0, [x29, 76]
	mul	w2, w2, w0
	ldr	w0, [x29, 72]
	add	w0, w2, w0
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0]
	str	w0, [x29, 52]
	str	wzr, [x29, 68]
	b	L7
L8:
	ldr	x0, [x29, 24]
	ldr	x1, [x0, 8]
	ldr	x0, [x29, 24]
	ldr	w2, [x0, 4]
	ldr	w0, [x29, 76]
	mul	w2, w2, w0
	ldr	w0, [x29, 68]
	add	w0, w2, w0
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w2, [x0]
	ldr	x0, [x29, 32]
	ldr	x1, [x0, 8]
	ldr	x0, [x29, 32]
	ldr	w3, [x0, 4]
	ldr	w0, [x29, 72]
	mul	w3, w3, w0
	ldr	w0, [x29, 68]
	add	w0, w3, w0
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w1, [x0]
	ldr	w0, [x29, 52]
	mul	w1, w1, w0
	ldr	x0, [x29, 24]
	ldr	x3, [x0, 8]
	ldr	x0, [x29, 24]
	ldr	w4, [x0, 4]
	ldr	w0, [x29, 76]
	mul	w4, w4, w0
	ldr	w0, [x29, 68]
	add	w0, w4, w0
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x3, x0
	add	w1, w2, w1
	str	w1, [x0]
	ldr	w0, [x29, 68]
	add	w0, w0, 1
	str	w0, [x29, 68]
L7:
	ldr	x0, [x29, 32]
	ldr	w0, [x0, 4]
	ldr	w1, [x29, 68]
	cmp	w1, w0
	blt	L8
	ldr	w0, [x29, 72]
	add	w0, w0, 1
	str	w0, [x29, 72]
L6:
	ldr	x0, [x29, 40]
	ldr	w0, [x0, 4]
	ldr	w1, [x29, 72]
	cmp	w1, w0
	blt	L9
	ldr	w0, [x29, 76]
	add	w0, w0, 1
	str	w0, [x29, 76]
L5:
	ldr	x0, [x29, 40]
	ldr	w0, [x0]
	ldr	w1, [x29, 76]
	cmp	w1, w0
	blt	L10
L1:
	ldp	x29, x30, [sp], 80
LCFI2:
	ret
LFE10:
	.cstring
	.align	3
lC2:
	.ascii "%d \0"
	.align	3
lC3:
	.ascii "\0"
	.text
	.align	2
	.globl _print_matrix
_print_matrix:
LFB11:
	sub	sp, sp, #64
LCFI3:
	stp	x29, x30, [sp, 16]
LCFI4:
	add	x29, sp, 16
LCFI5:
	str	x0, [x29, 24]
	str	wzr, [x29, 44]
	b	L12
L15:
	str	wzr, [x29, 40]
	b	L13
L14:
	ldr	x0, [x29, 24]
	ldr	x1, [x0, 8]
	ldr	x0, [x29, 24]
	ldr	w2, [x0]
	ldr	w0, [x29, 44]
	mul	w2, w2, w0
	ldr	w0, [x29, 40]
	add	w0, w2, w0
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0]
	str	w0, [sp]
	adrp	x0, lC2@PAGE
	add	x0, x0, lC2@PAGEOFF;
	bl	_printf
	ldr	w0, [x29, 40]
	add	w0, w0, 1
	str	w0, [x29, 40]
L13:
	ldr	x0, [x29, 24]
	ldr	w0, [x0, 4]
	ldr	w1, [x29, 40]
	cmp	w1, w0
	blt	L14
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	_puts
	ldr	w0, [x29, 44]
	add	w0, w0, 1
	str	w0, [x29, 44]
L12:
	ldr	x0, [x29, 24]
	ldr	w0, [x0]
	ldr	w1, [x29, 44]
	cmp	w1, w0
	blt	L15
	nop
	nop
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 64
LCFI6:
	ret
LFE11:
	.align	2
	.globl _init_random
_init_random:
LFB12:
	stp	x29, x30, [sp, -48]!
LCFI7:
	mov	x29, sp
LCFI8:
	str	x0, [x29, 24]
	str	w1, [x29, 20]
	str	wzr, [x29, 44]
	b	L17
L18:
	bl	_rand
	ldrsw	x1, [x29, 44]
	lsl	x1, x1, 2
	ldr	x2, [x29, 24]
	add	x1, x2, x1
	mov	w2, 100
	sdiv	w3, w0, w2
	mov	w2, 100
	mul	w2, w3, w2
	sub	w0, w0, w2
	str	w0, [x1]
	ldr	w0, [x29, 44]
	add	w0, w0, 1
	str	w0, [x29, 44]
L17:
	ldr	w1, [x29, 44]
	ldr	w0, [x29, 20]
	cmp	w1, w0
	blt	L18
	nop
	nop
	ldp	x29, x30, [sp], 48
LCFI9:
	ret
LFE12:
	.cstring
	.align	3
lC4:
	.ascii "Time elapsed : %lf(ms)\12\0"
	.text
	.align	2
	.globl _main
_main:
LFB13:
	sub	sp, sp, #128
LCFI10:
	sub	sp, sp, #6291456
LCFI11:
	stp	x29, x30, [sp, 16]
LCFI12:
	add	x29, sp, 16
LCFI13:
	mov	w0, 768
	add	x1, x29, 6291456
	str	w0, [x1, 88]
	mov	w0, 1024
	add	x1, x29, 6291456
	str	w0, [x1, 92]
	mov	w0, 1024
	add	x1, x29, 6291456
	str	w0, [x1, 72]
	mov	w0, 768
	add	x1, x29, 6291456
	str	w0, [x1, 76]
	add	x0, x29, 3145728
	add	x0, x0, 72
	mov	w1, 786432
	bl	_init_random
	add	x0, x29, 72
	mov	w1, 786432
	bl	_init_random
	add	x0, x29, 3145728
	add	x0, x0, 72
	add	x1, x29, 6291456
	str	x0, [x1, 96]
	add	x0, x29, 72
	add	x1, x29, 6291456
	str	x0, [x1, 80]
	stp	xzr, xzr, [x29, 56]
	add	x0, x29, 40
	mov	x1, x0
	mov	w0, 6
	bl	_clock_gettime
	add	x2, x29, 56
	add	x1, x29, 6291456
	add	x1, x1, 72
	add	x0, x29, 6291456
	add	x0, x0, 88
	bl	_matmul
	add	x0, x29, 24
	mov	x1, x0
	mov	w0, 6
	bl	_clock_gettime
	ldr	x0, [x29, 64]
	bl	_free
	ldr	x1, [x29, 24]
	ldr	x0, [x29, 40]
	sub	x0, x1, x0
	fmov	d31, x0
	scvtf	d31, d31
	mov	x0, 70368744177664
	movk	x0, 0x408f, lsl 48
	fmov	d30, x0
	fmul	d30, d31, d30
	ldr	x1, [x29, 32]
	ldr	x0, [x29, 48]
	sub	x0, x1, x0
	fmov	d31, x0
	scvtf	d31, d31
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d29, x0
	fdiv	d31, d31, d29
	fadd	d31, d30, d31
	add	x0, x29, 6291456
	str	d31, [x0, 104]
	add	x0, x29, 6291456
	ldr	d31, [x0, 104]
	str	d31, [sp]
	adrp	x0, lC4@PAGE
	add	x0, x0, lC4@PAGEOFF;
	bl	_printf
	mov	w0, 0
	ldp	x29, x30, [sp, 16]
LCFI14:
	add	sp, sp, 128
LCFI15:
	add	sp, sp, 6291456
LCFI16:
	ret
LFE13:
	.section __TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame1:
	.set L$set$0,LECIE1-LSCIE1
	.long L$set$0
LSCIE1:
	.long	0
	.byte	0x3
	.ascii "zR\0"
	.uleb128 0x1
	.sleb128 -8
	.uleb128 0x1e
	.uleb128 0x1
	.byte	0x10
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LECIE1:
LSFDE1:
	.set L$set$1,LEFDE1-LASFDE1
	.long L$set$1
LASFDE1:
	.long	LASFDE1-EH_frame1
	.quad	LFB10-.
	.set L$set$2,LFE10-LFB10
	.quad L$set$2
	.uleb128 0
	.byte	0x4
	.set L$set$3,LCFI0-LFB10
	.long L$set$3
	.byte	0xe
	.uleb128 0x50
	.byte	0x9d
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x9
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$5,LCFI2-LCFI1
	.long L$set$5
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE1:
LSFDE3:
	.set L$set$6,LEFDE3-LASFDE3
	.long L$set$6
LASFDE3:
	.long	LASFDE3-EH_frame1
	.quad	LFB11-.
	.set L$set$7,LFE11-LFB11
	.quad L$set$7
	.uleb128 0
	.byte	0x4
	.set L$set$8,LCFI3-LFB11
	.long L$set$8
	.byte	0xe
	.uleb128 0x40
	.byte	0x4
	.set L$set$9,LCFI4-LCFI3
	.long L$set$9
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$10,LCFI5-LCFI4
	.long L$set$10
	.byte	0xc
	.uleb128 0x1d
	.uleb128 0x30
	.byte	0x4
	.set L$set$11,LCFI6-LCFI5
	.long L$set$11
	.byte	0xdd
	.byte	0xde
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE3:
LSFDE5:
	.set L$set$12,LEFDE5-LASFDE5
	.long L$set$12
LASFDE5:
	.long	LASFDE5-EH_frame1
	.quad	LFB12-.
	.set L$set$13,LFE12-LFB12
	.quad L$set$13
	.uleb128 0
	.byte	0x4
	.set L$set$14,LCFI7-LFB12
	.long L$set$14
	.byte	0xe
	.uleb128 0x30
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$15,LCFI8-LCFI7
	.long L$set$15
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$16,LCFI9-LCFI8
	.long L$set$16
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE5:
LSFDE7:
	.set L$set$17,LEFDE7-LASFDE7
	.long L$set$17
LASFDE7:
	.long	LASFDE7-EH_frame1
	.quad	LFB13-.
	.set L$set$18,LFE13-LFB13
	.quad L$set$18
	.uleb128 0
	.byte	0x4
	.set L$set$19,LCFI10-LFB13
	.long L$set$19
	.byte	0xe
	.uleb128 0x80
	.byte	0x4
	.set L$set$20,LCFI11-LCFI10
	.long L$set$20
	.byte	0xe
	.uleb128 0x600080
	.byte	0x4
	.set L$set$21,LCFI12-LCFI11
	.long L$set$21
	.byte	0x9d
	.uleb128 0xc000e
	.byte	0x9e
	.uleb128 0xc000d
	.byte	0x4
	.set L$set$22,LCFI13-LCFI12
	.long L$set$22
	.byte	0xc
	.uleb128 0x1d
	.uleb128 0x600070
	.byte	0x4
	.set L$set$23,LCFI14-LCFI13
	.long L$set$23
	.byte	0xdd
	.byte	0xde
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0x600080
	.byte	0x4
	.set L$set$24,LCFI15-LCFI14
	.long L$set$24
	.byte	0xe
	.uleb128 0x600000
	.byte	0x4
	.set L$set$25,LCFI16-LCFI15
	.long L$set$25
	.byte	0xe
	.uleb128 0
	.align	3
LEFDE7:
	.ident	"GCC: (Homebrew GCC 15.1.0) 15.1.0"
	.subsections_via_symbols
