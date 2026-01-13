	.arch armv8.5-a
	.build_version macos,  14, 0
	.text
	.align	2
	.p2align 5,,15
_matmul._omp_fn.0:
LFB14:
	stp	x29, x30, [sp, -48]!
LCFI0:
	mov	x29, sp
LCFI1:
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
LCFI2:
	mov	x22, x0
	ldr	x19, [x0]
	bl	_omp_get_num_threads
	mov	w20, w0
	bl	_omp_get_thread_num
	ldr	w21, [x19]
	sdiv	w12, w21, w20
	msub	w1, w12, w20, w21
	cmp	w0, w1
	cinc	w12, w12, lt
	csel	w1, w1, wzr, ge
	madd	w6, w12, w0, w1
	add	w12, w12, w6
	cmp	w6, w12
	bge	L1
	ldp	x7, x8, [x22, 8]
	ldr	w0, [x19, 4]
	.p2align 5,,15
L5:
	cmp	w0, 0
	ble	L8
	ldr	x11, [x19, 8]
	mov	w5, 0
	ldr	w1, [x7, 4]
	.p2align 5,,15
L7:
	cmp	w1, 0
	ble	L10
	madd	w0, w6, w0, w5
	ldr	x9, [x7, 8]
	mov	w2, 0
	ldr	x3, [x8, 8]
	ldr	w10, [x11, w0, sxtw 2]
	.p2align 5,,15
L9:
	madd	w1, w5, w1, w2
	ldr	w0, [x8, 4]
	ldr	w1, [x9, x1, lsl 2]
	madd	w0, w6, w0, w2
	add	w2, w2, 1
	sbfiz	x0, x0, 2, 32
	ldr	w4, [x3, x0]
	madd	w1, w10, w1, w4
	str	w1, [x3, x0]
	ldr	w1, [x7, 4]
	cmp	w1, w2
	bgt	L9
	ldr	w0, [x19, 4]
L10:
	add	w5, w5, 1
	cmp	w0, w5
	bgt	L7
L8:
	add	w6, w6, 1
	cmp	w12, w6
	bne	L5
L1:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
LCFI3:
	ret
LFE14:
	.cstring
	.align	3
lC0:
	.ascii "Shape mismatch!\0"
	.align	3
lC1:
	.ascii "Realloc failed!\0"
	.text
	.align	2
	.p2align 5,,15
	.globl _matmul
_matmul:
LFB10:
	stp	x29, x30, [sp, -80]!
LCFI4:
	mov	x29, sp
LCFI5:
	str	x21, [sp, 32]
LCFI6:
	mov	x21, x1
	stp	x19, x20, [sp, 16]
LCFI7:
	mov	x20, x0
	ldr	w1, [x0, 4]
	ldr	w0, [x21]
	cmp	w1, w0
	beq	L18
	adrp	x0, lC0@PAGE
	add	x0, x0, lC0@PAGEOFF;
L21:
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 80
LCFI8:
	b	_printf
	.p2align 2,,3
L18:
LCFI9:
	ldr	w0, [x21, 4]
	mov	x19, x2
	ldr	w1, [x20]
	stp	w1, w0, [x2]
	smull	x1, w1, w0
	ldr	x0, [x2, 8]
	lsl	x1, x1, 2
	bl	_realloc
	cbz	x0, L22
	ldp	w1, w2, [x19]
	str	x0, [x19, 8]
	smull	x2, w2, w1
	mov	w1, 0
	lsl	x2, x2, 2
	bl	_memset
	adrp	x0, _matmul._omp_fn.0@PAGE
	add	x1, x29, 48
	stp	x20, x21, [x29, 48]
	mov	w3, 0
	mov	w2, 0
	add	x0, x0, _matmul._omp_fn.0@PAGEOFF;
	str	x19, [x29, 64]
	bl	_GOMP_parallel
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 80
LCFI10:
	ret
L22:
LCFI11:
	adrp	x0, lC1@PAGE
	add	x0, x0, lC1@PAGEOFF;
	b	L21
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
	.p2align 5,,15
	.globl _print_matrix
_print_matrix:
LFB11:
	sub	sp, sp, #80
LCFI12:
	stp	x29, x30, [sp, 16]
LCFI13:
	add	x29, sp, 16
LCFI14:
	stp	x19, x20, [sp, 32]
LCFI15:
	mov	x20, x0
	ldr	w0, [x0]
	cmp	w0, 0
	ble	L23
	stp	x21, x22, [x29, 32]
LCFI16:
	adrp	x22, lC2@PAGE
	mov	w21, 0
	add	x22, x22, lC2@PAGEOFF;
	str	x23, [x29, 48]
LCFI17:
	adrp	x23, lC3@PAGE
	add	x23, x23, lC3@PAGEOFF;
	.p2align 5,,15
L24:
	ldr	w1, [x20, 4]
	mov	w19, 0
	cmp	w1, 0
	bgt	L26
	b	L27
	.p2align 2,,3
L36:
	ldr	w0, [x20]
L26:
	madd	w0, w21, w0, w19
	add	w19, w19, 1
	ldr	x1, [x20, 8]
	ldr	w0, [x1, w0, sxtw 2]
	str	w0, [sp]
	mov	x0, x22
	bl	_printf
	ldr	w0, [x20, 4]
	cmp	w0, w19
	bgt	L36
L27:
	mov	x0, x23
	add	w21, w21, 1
	bl	_puts
	ldr	w0, [x20]
	cmp	w0, w21
	bgt	L24
	ldr	x23, [x29, 48]
LCFI18:
	ldp	x21, x22, [x29, 32]
LCFI19:
L23:
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 80
LCFI20:
	ret
LFE11:
	.align	2
	.p2align 5,,15
	.globl _init_random
_init_random:
LFB12:
	cmp	w1, 0
	ble	L42
	stp	x29, x30, [sp, -48]!
LCFI21:
	mov	x29, sp
LCFI22:
	stp	x19, x20, [sp, 16]
LCFI23:
	mov	x19, x0
	mov	w20, 100
	str	x21, [sp, 32]
LCFI24:
	add	x21, x0, w1, uxtw 2
	.p2align 5,,15
L39:
	bl	_rand
	sdiv	w1, w0, w20
	msub	w1, w1, w20, w0
	str	w1, [x19], 4
	cmp	x19, x21
	bne	L39
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
LCFI25:
	ret
	.p2align 2,,3
L42:
	ret
LFE12:
	.cstring
	.align	3
lC4:
	.ascii "Time elapsed : %lf(ms)\12\0"
	.section __TEXT,__text_startup,regular,pure_instructions
	.align	2
	.p2align 5,,15
	.globl _main
_main:
LFB13:
	sub	sp, sp, #128
LCFI26:
	adrp	x0, lC5@PAGE
	mov	x1, 3145728
	stp	x29, x30, [sp, 16]
LCFI27:
	add	x29, sp, 16
LCFI28:
	ldr	d31, [x0, #lC5@PAGEOFF]
	adrp	x0, lC6@PAGE
	stp	x19, x20, [sp, 32]
LCFI29:
	str	d31, [x29, 32]
	ldr	d31, [x0, #lC6@PAGEOFF]
	mov	x0, 64
	str	d31, [x29, 48]
	bl	_aligned_alloc
	mov	x20, x0
	mov	x1, 3145728
	mov	x0, 64
	bl	_aligned_alloc
	mov	x19, x0
	mov	w1, 2
	mov	x0, x20
	bl	_init_random
	mov	x0, x19
	mov	w1, 2
	bl	_init_random
	add	x1, x29, 80
	mov	w0, 6
	str	x20, [x29, 40]
	str	x19, [x29, 56]
	stp	xzr, xzr, [x29, 64]
	bl	_clock_gettime
	add	x2, x29, 64
	add	x1, x29, 48
	add	x0, x29, 32
	bl	_matmul
	add	x1, x29, 96
	mov	w0, 6
	bl	_clock_gettime
	ldr	x0, [x29, 72]
	bl	_free
	mov	x0, x20
	bl	_free
	mov	x0, x19
	bl	_free
	ldr	x1, [x29, 80]
	ldr	x0, [x29, 96]
	sub	x0, x0, x1
	ldr	x1, [x29, 88]
	scvtf	d30, x0
	ldr	x0, [x29, 104]
	sub	x0, x0, x1
	scvtf	d31, x0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d29, x0
	mov	x0, 70368744177664
	movk	x0, 0x408f, lsl 48
	fdiv	d31, d31, d29
	fmov	d29, x0
	adrp	x0, lC4@PAGE
	add	x0, x0, lC4@PAGEOFF;
	fmadd	d31, d30, d29, d31
	str	d31, [sp]
	bl	_printf
	ldp	x29, x30, [sp, 16]
	mov	w0, 0
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 128
LCFI30:
	ret
LFE13:
	.const
	.align	3
lC5:
	.word	768
	.word	1024
	.align	3
lC6:
	.word	1024
	.word	768
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
	.quad	LFB14-.
	.set L$set$2,LFE14-LFB14
	.quad L$set$2
	.uleb128 0
	.byte	0x4
	.set L$set$3,LCFI0-LFB14
	.long L$set$3
	.byte	0xe
	.uleb128 0x30
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$5,LCFI2-LCFI1
	.long L$set$5
	.byte	0x93
	.uleb128 0x4
	.byte	0x94
	.uleb128 0x3
	.byte	0x95
	.uleb128 0x2
	.byte	0x96
	.uleb128 0x1
	.byte	0x4
	.set L$set$6,LCFI3-LCFI2
	.long L$set$6
	.byte	0xde
	.byte	0xdd
	.byte	0xd5
	.byte	0xd6
	.byte	0xd3
	.byte	0xd4
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE1:
LSFDE3:
	.set L$set$7,LEFDE3-LASFDE3
	.long L$set$7
LASFDE3:
	.long	LASFDE3-EH_frame1
	.quad	LFB10-.
	.set L$set$8,LFE10-LFB10
	.quad L$set$8
	.uleb128 0
	.byte	0x4
	.set L$set$9,LCFI4-LFB10
	.long L$set$9
	.byte	0xe
	.uleb128 0x50
	.byte	0x9d
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x9
	.byte	0x4
	.set L$set$10,LCFI5-LCFI4
	.long L$set$10
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$11,LCFI6-LCFI5
	.long L$set$11
	.byte	0x95
	.uleb128 0x6
	.byte	0x4
	.set L$set$12,LCFI7-LCFI6
	.long L$set$12
	.byte	0x93
	.uleb128 0x8
	.byte	0x94
	.uleb128 0x7
	.byte	0x4
	.set L$set$13,LCFI8-LCFI7
	.long L$set$13
	.byte	0xa
	.byte	0xde
	.byte	0xdd
	.byte	0xd5
	.byte	0xd3
	.byte	0xd4
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.byte	0x4
	.set L$set$14,LCFI9-LCFI8
	.long L$set$14
	.byte	0xb
	.byte	0x4
	.set L$set$15,LCFI10-LCFI9
	.long L$set$15
	.byte	0xa
	.byte	0xde
	.byte	0xdd
	.byte	0xd5
	.byte	0xd3
	.byte	0xd4
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.byte	0x4
	.set L$set$16,LCFI11-LCFI10
	.long L$set$16
	.byte	0xb
	.align	3
LEFDE3:
LSFDE5:
	.set L$set$17,LEFDE5-LASFDE5
	.long L$set$17
LASFDE5:
	.long	LASFDE5-EH_frame1
	.quad	LFB11-.
	.set L$set$18,LFE11-LFB11
	.quad L$set$18
	.uleb128 0
	.byte	0x4
	.set L$set$19,LCFI12-LFB11
	.long L$set$19
	.byte	0xe
	.uleb128 0x50
	.byte	0x4
	.set L$set$20,LCFI13-LCFI12
	.long L$set$20
	.byte	0x9d
	.uleb128 0x8
	.byte	0x9e
	.uleb128 0x7
	.byte	0x4
	.set L$set$21,LCFI14-LCFI13
	.long L$set$21
	.byte	0xc
	.uleb128 0x1d
	.uleb128 0x40
	.byte	0x4
	.set L$set$22,LCFI15-LCFI14
	.long L$set$22
	.byte	0x93
	.uleb128 0x6
	.byte	0x94
	.uleb128 0x5
	.byte	0x4
	.set L$set$23,LCFI16-LCFI15
	.long L$set$23
	.byte	0x96
	.uleb128 0x3
	.byte	0x95
	.uleb128 0x4
	.byte	0x4
	.set L$set$24,LCFI17-LCFI16
	.long L$set$24
	.byte	0x97
	.uleb128 0x2
	.byte	0x4
	.set L$set$25,LCFI18-LCFI17
	.long L$set$25
	.byte	0xd7
	.byte	0x4
	.set L$set$26,LCFI19-LCFI18
	.long L$set$26
	.byte	0xd6
	.byte	0xd5
	.byte	0x4
	.set L$set$27,LCFI20-LCFI19
	.long L$set$27
	.byte	0xd3
	.byte	0xd4
	.byte	0xdd
	.byte	0xde
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE5:
LSFDE7:
	.set L$set$28,LEFDE7-LASFDE7
	.long L$set$28
LASFDE7:
	.long	LASFDE7-EH_frame1
	.quad	LFB12-.
	.set L$set$29,LFE12-LFB12
	.quad L$set$29
	.uleb128 0
	.byte	0x4
	.set L$set$30,LCFI21-LFB12
	.long L$set$30
	.byte	0xe
	.uleb128 0x30
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$31,LCFI22-LCFI21
	.long L$set$31
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$32,LCFI23-LCFI22
	.long L$set$32
	.byte	0x93
	.uleb128 0x4
	.byte	0x94
	.uleb128 0x3
	.byte	0x4
	.set L$set$33,LCFI24-LCFI23
	.long L$set$33
	.byte	0x95
	.uleb128 0x2
	.byte	0x4
	.set L$set$34,LCFI25-LCFI24
	.long L$set$34
	.byte	0xde
	.byte	0xdd
	.byte	0xd5
	.byte	0xd3
	.byte	0xd4
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE7:
LSFDE9:
	.set L$set$35,LEFDE9-LASFDE9
	.long L$set$35
LASFDE9:
	.long	LASFDE9-EH_frame1
	.quad	LFB13-.
	.set L$set$36,LFE13-LFB13
	.quad L$set$36
	.uleb128 0
	.byte	0x4
	.set L$set$37,LCFI26-LFB13
	.long L$set$37
	.byte	0xe
	.uleb128 0x80
	.byte	0x4
	.set L$set$38,LCFI27-LCFI26
	.long L$set$38
	.byte	0x9d
	.uleb128 0xe
	.byte	0x9e
	.uleb128 0xd
	.byte	0x4
	.set L$set$39,LCFI28-LCFI27
	.long L$set$39
	.byte	0xc
	.uleb128 0x1d
	.uleb128 0x70
	.byte	0x4
	.set L$set$40,LCFI29-LCFI28
	.long L$set$40
	.byte	0x93
	.uleb128 0xc
	.byte	0x94
	.uleb128 0xb
	.byte	0x4
	.set L$set$41,LCFI30-LCFI29
	.long L$set$41
	.byte	0xd3
	.byte	0xd4
	.byte	0xdd
	.byte	0xde
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE9:
	.ident	"GCC: (Homebrew GCC 15.1.0) 15.1.0"
	.subsections_via_symbols
