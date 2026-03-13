#include "textflag.h"

DATA hash_dispatch_table<>+0(SB)/8, $hash_tail_0<>(SB)
DATA hash_dispatch_table<>+8(SB)/8, $hash_tail_1<>(SB)
DATA hash_dispatch_table<>+16(SB)/8, $hash_tail_2<>(SB)
DATA hash_dispatch_table<>+24(SB)/8, $hash_tail_3<>(SB)
DATA hash_dispatch_table<>+32(SB)/8, $hash_tail_4<>(SB)
DATA hash_dispatch_table<>+40(SB)/8, $hash_tail_5<>(SB)
DATA hash_dispatch_table<>+48(SB)/8, $hash_tail_6<>(SB)
DATA hash_dispatch_table<>+56(SB)/8, $hash_tail_7<>(SB)
DATA hash_dispatch_table<>+64(SB)/8, $hash_tail_8<>(SB)
DATA hash_dispatch_table<>+72(SB)/8, $hash_tail_9<>(SB)
DATA hash_dispatch_table<>+80(SB)/8, $hash_tail_10<>(SB)
DATA hash_dispatch_table<>+88(SB)/8, $hash_tail_11<>(SB)
DATA hash_dispatch_table<>+96(SB)/8, $hash_tail_12<>(SB)
DATA hash_dispatch_table<>+104(SB)/8, $hash_tail_13<>(SB)
DATA hash_dispatch_table<>+112(SB)/8, $hash_tail_14<>(SB)
DATA hash_dispatch_table<>+120(SB)/8, $hash_tail_15<>(SB)
GLOBL hash_dispatch_table<>(SB), RODATA|NOPTR, $128

DATA pbf5_test_vec<>+0(SB)/8, $0xffffffffffffffff
DATA pbf5_test_vec<>+8(SB)/8, $0x00000000ffffffff
DATA pbf5_test_vec<>+16(SB)/8, $0xffffffffffffffff
DATA pbf5_test_vec<>+24(SB)/8, $0x0000000000000000
GLOBL pbf5_test_vec<>(SB), RODATA|NOPTR, $32
DATA pbf5_test_mask31<>+0(SB)/4, $0x0000001f
GLOBL pbf5_test_mask31<>(SB), RODATA|NOPTR, $4
DATA pbf5_test_one<>+0(SB)/4, $0x00000001
GLOBL pbf5_test_one<>(SB), RODATA|NOPTR, $4

DATA pbf6_test_vec<>+0(SB)/8, $0xffffffffffffffff
DATA pbf6_test_vec<>+8(SB)/8, $0x00000000ffffffff
DATA pbf6_test_vec<>+16(SB)/8, $0xffffffffffffffff
DATA pbf6_test_vec<>+24(SB)/8, $0x00000000ffffffff
GLOBL pbf6_test_vec<>(SB), RODATA|NOPTR, $32
DATA pbf6_test_mask31<>+0(SB)/4, $0x0000001f
GLOBL pbf6_test_mask31<>(SB), RODATA|NOPTR, $4
DATA pbf6_test_one<>+0(SB)/4, $0x00000001
GLOBL pbf6_test_one<>(SB), RODATA|NOPTR, $4

DATA pbf7_test_vec<>+0(SB)/8, $0xffffffffffffffff
DATA pbf7_test_vec<>+8(SB)/8, $0xffffffffffffffff
DATA pbf7_test_vec<>+16(SB)/8, $0xffffffffffffffff
DATA pbf7_test_vec<>+24(SB)/8, $0x00000000ffffffff
GLOBL pbf7_test_vec<>(SB), RODATA|NOPTR, $32
DATA pbf7_test_mask31<>+0(SB)/4, $0x0000001f
GLOBL pbf7_test_mask31<>(SB), RODATA|NOPTR, $4
DATA pbf7_test_one<>+0(SB)/4, $0x00000001
GLOBL pbf7_test_one<>(SB), RODATA|NOPTR, $4

DATA pbf8_test_mask31<>+0(SB)/4, $0x0000001f
GLOBL pbf8_test_mask31<>(SB), RODATA|NOPTR, $4
DATA pbf8_test_one<>+0(SB)/4, $0x00000001
GLOBL pbf8_test_one<>(SB), RODATA|NOPTR, $4

TEXT _ZN3pbf4HashEPKhj(SB), NOSPLIT, $0
	// movabs $0xdeadbeefdeadbeef,%r8
	MOVQ $0xdeadbeefdeadbeef, R8
	// mov    %esi,%r9d
	MOVL SI, R9
	// and    $0xffffffe0,%r9d
	ANDL $0xffffffe0, R9
	// je     1a9 <_ZN3pbf4HashEPKhj+0x1a9>
	JEQ L_zn3pbf4hashepkhj_01a9
	// add    %rdi,%r9
	ADDQ DI, R9
	// xor    %r10d,%r10d
	XORL R10, R10
	// mov    %r8,%rax
	MOVQ R8, AX
	// mov    %r8,%rdx
	MOVQ R8, DX
	// xor    %ecx,%ecx
	XORL CX, CX
	// data16 cs nopw 0x0(%rax,%rax,1)
	NOP
L_zn3pbf4hashepkhj_0030:
	// add    (%rdi),%rdx
	ADDQ (DI), DX
	// add    0x8(%rdi),%rax
	ADDQ 0x8(DI), AX
	// rorx   $0xe,%rdx,%rdx
	RORXQ $0xe, DX, DX
	// add    %rax,%rdx
	ADDQ AX, DX
	// xor    %rdx,%rcx
	XORQ DX, CX
	// rorx   $0xc,%rax,%rax
	RORXQ $0xc, AX, AX
	// add    %rcx,%rax
	ADDQ CX, AX
	// xor    %rax,%r10
	XORQ AX, R10
	// rorx   $0x22,%rcx,%rcx
	RORXQ $0x22, CX, CX
	// add    %r10,%rcx
	ADDQ R10, CX
	// xor    %rcx,%rdx
	XORQ CX, DX
	// rorx   $0x17,%r10,%r10
	RORXQ $0x17, R10, R10
	// add    %rdx,%r10
	ADDQ DX, R10
	// xor    %r10,%rax
	XORQ R10, AX
	// rorx   $0xa,%rdx,%rdx
	RORXQ $0xa, DX, DX
	// add    %rax,%rdx
	ADDQ AX, DX
	// xor    %rdx,%rcx
	XORQ DX, CX
	// rorx   $0x10,%rax,%rax
	RORXQ $0x10, AX, AX
	// add    %rcx,%rax
	ADDQ CX, AX
	// xor    %rax,%r10
	XORQ AX, R10
	// rorx   $0x1a,%rcx,%rcx
	RORXQ $0x1a, CX, CX
	// add    %r10,%rcx
	ADDQ R10, CX
	// xor    %rcx,%rdx
	XORQ CX, DX
	// rorx   $0x1b,%r10,%r10
	RORXQ $0x1b, R10, R10
	// add    %rdx,%r10
	ADDQ DX, R10
	// xor    %r10,%rax
	XORQ R10, AX
	// rorx   $0x2,%rdx,%rdx
	RORXQ $0x2, DX, DX
	// add    %rax,%rdx
	ADDQ AX, DX
	// xor    %rdx,%rcx
	XORQ DX, CX
	// rorx   $0x1e,%rax,%rax
	RORXQ $0x1e, AX, AX
	// add    %rcx,%rax
	ADDQ CX, AX
	// xor    %rax,%r10
	XORQ AX, R10
	// rorx   $0x3b,%rcx,%rcx
	RORXQ $0x3b, CX, CX
	// add    %r10,%rcx
	ADDQ R10, CX
	// xor    %rcx,%rdx
	XORQ CX, DX
	// rorx   $0x1c,%r10,%r10
	RORXQ $0x1c, R10, R10
	// add    %rdx,%r10
	ADDQ DX, R10
	// xor    %r10,%rax
	XORQ R10, AX
	// add    0x10(%rdi),%rcx
	ADDQ 0x10(DI), CX
	// add    0x18(%rdi),%r10
	ADDQ 0x18(DI), R10
	// add    $0x20,%rdi
	ADDQ $0x20, DI
	// cmp    %r9,%rdi
	CMPQ R9, DI
	// jb     30 <_ZN3pbf4HashEPKhj+0x30>
	JB L_zn3pbf4hashepkhj_0030
	// test   $0x10,%sil
	TESTB $0x10, SIB
	// je     181 <_ZN3pbf4HashEPKhj+0x181>
	JEQ L_zn3pbf4hashepkhj_0181
L_zn3pbf4hashepkhj_00e6:
	// add    (%rdi),%rdx
	ADDQ (DI), DX
	// add    0x8(%rdi),%rax
	ADDQ 0x8(DI), AX
	// rorx   $0xe,%rdx,%rdx
	RORXQ $0xe, DX, DX
	// add    %rax,%rdx
	ADDQ AX, DX
	// xor    %rdx,%rcx
	XORQ DX, CX
	// rorx   $0xc,%rax,%rax
	RORXQ $0xc, AX, AX
	// add    %rcx,%rax
	ADDQ CX, AX
	// xor    %rax,%r10
	XORQ AX, R10
	// rorx   $0x22,%rcx,%rcx
	RORXQ $0x22, CX, CX
	// add    %r10,%rcx
	ADDQ R10, CX
	// xor    %rcx,%rdx
	XORQ CX, DX
	// rorx   $0x17,%r10,%r9
	RORXQ $0x17, R10, R9
	// add    %rdx,%r9
	ADDQ DX, R9
	// xor    %r9,%rax
	XORQ R9, AX
	// rorx   $0xa,%rdx,%rdx
	RORXQ $0xa, DX, DX
	// add    %rax,%rdx
	ADDQ AX, DX
	// xor    %rdx,%rcx
	XORQ DX, CX
	// rorx   $0x10,%rax,%rax
	RORXQ $0x10, AX, AX
	// add    %rcx,%rax
	ADDQ CX, AX
	// xor    %rax,%r9
	XORQ AX, R9
	// rorx   $0x1a,%rcx,%rcx
	RORXQ $0x1a, CX, CX
	// add    %r9,%rcx
	ADDQ R9, CX
	// xor    %rcx,%rdx
	XORQ CX, DX
	// rorx   $0x1b,%r9,%r9
	RORXQ $0x1b, R9, R9
	// add    %rdx,%r9
	ADDQ DX, R9
	// xor    %r9,%rax
	XORQ R9, AX
	// rorx   $0x2,%rdx,%rdx
	RORXQ $0x2, DX, DX
	// add    %rax,%rdx
	ADDQ AX, DX
	// xor    %rdx,%rcx
	XORQ DX, CX
	// rorx   $0x1e,%rax,%rax
	RORXQ $0x1e, AX, AX
	// add    %rcx,%rax
	ADDQ CX, AX
	// xor    %rax,%r9
	XORQ AX, R9
	// rorx   $0x3b,%rcx,%rcx
	RORXQ $0x3b, CX, CX
	// add    %r9,%rcx
	ADDQ R9, CX
	// xor    %rcx,%rdx
	XORQ CX, DX
	// rorx   $0x1c,%r9,%r10
	RORXQ $0x1c, R9, R10
	// add    %rdx,%r10
	ADDQ DX, R10
	// xor    %r10,%rax
	XORQ R10, AX
	// add    $0x10,%rdi
	ADDQ $0x10, DI
L_zn3pbf4hashepkhj_0181:
	// mov    %rsi,%r9
	MOVQ SI, R9
	// shl    $0x38,%r9
	SHLQ $0x38, R9
	// add    %rax,%r9
	ADDQ AX, R9
	// and    $0xf,%esi
	ANDL $0xf, SI
	// lea    0x13f(%rip),%rax        # 2d4 <_ZN3pbf4HashEPKhj+0x2d4>
	LEAQ hash_dispatch_table<>(SB), AX
	// movslq (%rax,%rsi,4),%rsi
	MOVQ (AX)(SI*8), SI
	// add    %rax,%rsi
	// jmp    *%rsi
	JMP SI
L_zn3pbf4hashepkhj_01a9:
	// xor    %ecx,%ecx
	XORL CX, CX
	// xor    %r10d,%r10d
	XORL R10, R10
	// mov    %r8,%rdx
	MOVQ R8, DX
	// mov    %r8,%rax
	MOVQ R8, AX
	// test   $0x10,%sil
	TESTB $0x10, SIB
	// jne    e6 <_ZN3pbf4HashEPKhj+0xe6>
	JNE L_zn3pbf4hashepkhj_00e6
	// jmp    181 <_ZN3pbf4HashEPKhj+0x181>
	JMP L_zn3pbf4hashepkhj_0181

// jump table target for _ZN3pbf4HashEPKhj+0x19e (len % 16 == 0)
TEXT hash_tail_0<>(SB), NOSPLIT, $0
	// add    %r8,%rdx
	ADDQ R8, DX
	// add    %r8,%r9
	ADDQ R8, R9
	// jmp    24c <_ZN3pbf4HashEPKhj+0x24c>
	JMP hash_mix<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x1d6 (len % 16 == 1)
TEXT hash_tail_1<>(SB), NOSPLIT, $0
	// movzbl (%rdi),%eax
	MOVBLZX (DI), AX
	// add    %rax,%rdx
	ADDQ AX, DX
	// jmp    24c <_ZN3pbf4HashEPKhj+0x24c>
	JMP hash_mix<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x1cb (len % 16 == 2)
TEXT hash_tail_2<>(SB), NOSPLIT, $0
	// movzbl 0x1(%rdi),%eax
	MOVBLZX 0x1(DI), AX
	// shl    $0x8,%rax
	SHLQ $0x8, AX
	// add    %rax,%rdx
	ADDQ AX, DX
	JMP hash_tail_1<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x1c0 (len % 16 == 3)
TEXT hash_tail_3<>(SB), NOSPLIT, $0
	// movzbl 0x2(%rdi),%eax
	MOVBLZX 0x2(DI), AX
	// shl    $0x10,%rax
	SHLQ $0x10, AX
	// add    %rax,%rdx
	ADDQ AX, DX
	JMP hash_tail_2<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x1ff (len % 16 == 4)
TEXT hash_tail_4<>(SB), NOSPLIT, $0
	// mov    (%rdi),%eax
	MOVL (DI), AX
	// add    %rax,%rdx
	ADDQ AX, DX
	// jmp    24c <_ZN3pbf4HashEPKhj+0x24c>
	JMP hash_mix<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x1f4 (len % 16 == 5)
TEXT hash_tail_5<>(SB), NOSPLIT, $0
	// movzbl 0x4(%rdi),%eax
	MOVBLZX 0x4(DI), AX
	// shl    $0x20,%rax
	SHLQ $0x20, AX
	// add    %rax,%rdx
	ADDQ AX, DX
	JMP hash_tail_4<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x1e9 (len % 16 == 6)
TEXT hash_tail_6<>(SB), NOSPLIT, $0
	// movzbl 0x5(%rdi),%eax
	MOVBLZX 0x5(DI), AX
	// shl    $0x28,%rax
	SHLQ $0x28, AX
	// add    %rax,%rdx
	ADDQ AX, DX
	JMP hash_tail_5<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x1de (len % 16 == 7)
TEXT hash_tail_7<>(SB), NOSPLIT, $0
	// movzbl 0x6(%rdi),%eax
	MOVBLZX 0x6(DI), AX
	// shl    $0x30,%rax
	SHLQ $0x30, AX
	// add    %rax,%rdx
	ADDQ AX, DX
	JMP hash_tail_6<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x249 (len % 16 == 8)
TEXT hash_tail_8<>(SB), NOSPLIT, $0
	// add    (%rdi),%rdx
	ADDQ (DI), DX
	JMP hash_mix<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x21c (len % 16 == 9)
TEXT hash_tail_9<>(SB), NOSPLIT, $0
	// movzbl 0x8(%rdi),%eax
	MOVBLZX 0x8(DI), AX
	// jmp    246 <_ZN3pbf4HashEPKhj+0x246>
	JMP hash_tail_10<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x211 (len % 16 == 10)
TEXT hash_tail_10<>(SB), NOSPLIT, $0
	// add    %rax,%r9
	ADDQ AX, R9
	// add    (%rdi),%rdx
	ADDQ (DI), DX
	JMP hash_mix<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x206 (len % 16 == 11)
TEXT hash_tail_11<>(SB), NOSPLIT, $0
	// movzbl 0xa(%rdi),%eax
	MOVBLZX 0xa(DI), AX
	// shl    $0x10,%rax
	SHLQ $0x10, AX
	// add    %rax,%r9
	ADDQ AX, R9
	JMP hash_tail_10<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x243 (len % 16 == 12)
TEXT hash_tail_12<>(SB), NOSPLIT, $0
	// mov    0x8(%rdi),%eax
	MOVL 0x8(DI), AX
	JMP hash_tail_10<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x238 (len % 16 == 13)
TEXT hash_tail_13<>(SB), NOSPLIT, $0
	// movzbl 0xc(%rdi),%eax
	MOVBLZX 0xc(DI), AX
	// shl    $0x20,%rax
	SHLQ $0x20, AX
	// add    %rax,%r9
	ADDQ AX, R9
	JMP hash_tail_12<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x22d (len % 16 == 14)
TEXT hash_tail_14<>(SB), NOSPLIT, $0
	// movzbl 0xd(%rdi),%eax
	MOVBLZX 0xd(DI), AX
	// shl    $0x28,%rax
	SHLQ $0x28, AX
	// add    %rax,%r9
	ADDQ AX, R9
	JMP hash_tail_13<>(SB)

// jump table target for _ZN3pbf4HashEPKhj+0x222 (len % 16 == 15)
TEXT hash_tail_15<>(SB), NOSPLIT, $0
	// movzbl 0xe(%rdi),%eax
	MOVBLZX 0xe(DI), AX
	// shl    $0x30,%rax
	SHLQ $0x30, AX
	// add    %rax,%r9
	ADDQ AX, R9
	JMP hash_tail_14<>(SB)

// shared tail mixer for _ZN3pbf4HashEPKhj+0x24c
TEXT hash_mix<>(SB), NOSPLIT, $0
	// xor    %rdx,%r9
	XORQ DX, R9
	// rorx   $0x31,%rdx,%rax
	RORXQ $0x31, DX, AX
	// add    %rax,%r9
	ADDQ AX, R9
	// xor    %r9,%rcx
	XORQ R9, CX
	// rorx   $0xc,%r9,%rdx
	RORXQ $0xc, R9, DX
	// add    %rdx,%rcx
	ADDQ DX, CX
	// xor    %rcx,%r10
	XORQ CX, R10
	// rorx   $0x26,%rcx,%rcx
	RORXQ $0x26, CX, CX
	// add    %rcx,%r10
	ADDQ CX, R10
	// xor    %r10,%rax
	XORQ R10, AX
	// rorx   $0xd,%r10,%rsi
	RORXQ $0xd, R10, SI
	// add    %rsi,%rax
	ADDQ SI, AX
	// xor    %rax,%rdx
	XORQ AX, DX
	// rorx   $0x24,%rax,%rax
	RORXQ $0x24, AX, AX
	// add    %rax,%rdx
	ADDQ AX, DX
	// xor    %rdx,%rcx
	XORQ DX, CX
	// rorx   $0x37,%rdx,%rdi
	RORXQ $0x37, DX, DI
	// add    %rdi,%rcx
	ADDQ DI, CX
	// xor    %rcx,%rsi
	XORQ CX, SI
	// rorx   $0x11,%rcx,%rcx
	RORXQ $0x11, CX, CX
	// add    %rcx,%rsi
	ADDQ CX, SI
	// xor    %rsi,%rax
	XORQ SI, AX
	// rorx   $0xa,%rsi,%rdx
	RORXQ $0xa, SI, DX
	// add    %rdx,%rax
	ADDQ DX, AX
	// xor    %rax,%rdi
	XORQ AX, DI
	// rorx   $0x20,%rax,%rax
	RORXQ $0x20, AX, AX
	// add    %rdi,%rax
	ADDQ DI, AX
	// xor    %rax,%rcx
	XORQ AX, CX
	// rorx   $0x27,%rax,%rax
	RORXQ $0x27, AX, AX
	// add    %rcx,%rax
	ADDQ CX, AX
	// xor    %rax,%rdx
	XORQ AX, DX
	// rorx   $0x1,%rax,%rax
	RORXQ $0x1, AX, AX
	// add    %rax,%rdx
	ADDQ AX, DX
	// ret    
	RET

TEXT PBF4_Set(SB), NOSPLIT, $0
	// push   %rbp
	PUSHQ BP
	// push   %r15
	PUSHQ R15
	// push   %r14
	PUSHQ R14
	// push   %rbx
	PUSHQ BX
	// push   %rax
	SUBQ $8, SP
	// mov    %edx,%r15d
	MOVL DX, R15
	// mov    %esi,%ebx
	MOVL SI, BX
	// mov    %rdi,%r14
	MOVQ DI, R14
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// mov    %r8d,%esi
	MOVL R8, SI
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	MOVQ AX, CX
	// mov    %rax,%rsi
	MOVQ AX, SI
	// shr    $0x20,%rsi
	SHRQ $0x20, SI
	// rorx   $0x1c,%edx,%edi
	RORXL $0x1c, DX, DI
	// shr    $0x20,%rdx
	SHRQ $0x20, DX
	// rorx   $0x18,%ecx,%eax
	RORXL $0x18, CX, AX
	// rorx   $0x1a,%esi,%ebp
	RORXL $0x1a, SI, BP
	// xor    %eax,%edi
	XORL AX, DI
	// xor    %ebp,%edi
	XORL BP, DI
	// rorx   $0x1e,%edx,%eax
	RORXL $0x1e, DX, AX
	// xor    %edi,%eax
	XORL DI, AX
	// xor    %edx,%edx
	XORL DX, DX
	// div    %r15d
	DIVL R15
	// shlx   %rbx,%rdx,%rax
	SHLXQ BX, DX, AX
	// add    %r14,%rax
	ADDQ R14, AX
	// mov    %rcx,%r8
	MOVQ CX, R8
	// add    $0x3,%bl
	ADDB $0x3, BL
	// bzhi   %ebx,%ecx,%edi
	BZHIL BX, CX, DI
	// shr    $0x10,%rcx
	SHRQ $0x10, CX
	// shr    $0x30,%r8
	SHRQ $0x30, R8
	// movzwl %di,%ebp
	MOVWLZX DI, BP
	// and    $0x7,%dil
	ANDB $0x7, DIB
	// shr    $0x3,%rbp
	SHRQ $0x3, BP
	// movzbl 0x0(%rbp,%rax,1),%edx
	MOVBLZX (BP)(AX*1), DX
	// shrx   %edi,%edx,%r9d
	SHRXL DI, DX, R9
	// bts    %edi,%edx
	BTSL DI, DX
	// mov    %dl,0x0(%rbp,%rax,1)
	MOVB DL, (BP)(AX*1)
	// bzhi   %ebx,%ecx,%ecx
	BZHIL BX, CX, CX
	// movzwl %cx,%edx
	MOVWLZX CX, DX
	// mov    %ecx,%edi
	MOVL CX, DI
	// and    $0x7,%dil
	ANDB $0x7, DIB
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%ebp
	MOVBLZX (DX)(AX*1), BP
	// shrx   %edi,%ebp,%ecx
	SHRXL DI, BP, CX
	// and    %r9d,%ecx
	ANDL R9, CX
	// bts    %edi,%ebp
	BTSL DI, BP
	// mov    %bpl,(%rdx,%rax,1)
	MOVB BPB, (DX)(AX*1)
	// bzhi   %ebx,%esi,%edx
	BZHIL BX, SI, DX
	// movzwl %dx,%esi
	MOVWLZX DX, SI
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%edi
	MOVBLZX (SI)(AX*1), DI
	// shrx   %edx,%edi,%ebp
	SHRXL DX, DI, BP
	// bts    %edx,%edi
	BTSL DX, DI
	// mov    %dil,(%rsi,%rax,1)
	MOVB DIB, (SI)(AX*1)
	// bzhi   %ebx,%r8d,%edx
	BZHIL BX, R8, DX
	// mov    %edx,%esi
	MOVL DX, SI
	// and    $0x7,%sil
	ANDB $0x7, SIB
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%edi
	MOVBLZX (DX)(AX*1), DI
	// shrx   %esi,%edi,%ebx
	SHRXL SI, DI, BX
	// and    %ebp,%ebx
	ANDL BP, BX
	// and    %ecx,%ebx
	ANDL CX, BX
	// bts    %esi,%edi
	BTSL SI, DI
	// mov    %dil,(%rdx,%rax,1)
	MOVB DIB, (DX)(AX*1)
	// test   $0x1,%bl
	TESTB $0x1, BL
	// sete   %al
	SETEQ AL
	// add    $0x8,%rsp
	ADDQ $0x8, SP
	// pop    %rbx
	POPQ BX
	// pop    %r14
	POPQ R14
	// pop    %r15
	POPQ R15
	// pop    %rbp
	POPQ BP
	// ret
	RET

TEXT PBF4_Test(SB), NOSPLIT, $0
	// push   %rbp
	PUSHQ BP
	// push   %r15
	PUSHQ R15
	// push   %r14
	PUSHQ R14
	// push   %rbx
	PUSHQ BX
	// push   %rax
	SUBQ $8, SP
	// mov    %edx,%r15d
	MOVL DX, R15
	// mov    %esi,%ebx
	MOVL SI, BX
	// mov    %rdi,%r14
	MOVQ DI, R14
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// mov    %r8d,%esi
	MOVL R8, SI
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	MOVQ AX, CX
	// mov    %rax,%rsi
	MOVQ AX, SI
	// shr    $0x20,%rsi
	SHRQ $0x20, SI
	// rorx   $0x1c,%edx,%edi
	RORXL $0x1c, DX, DI
	// shr    $0x20,%rdx
	SHRQ $0x20, DX
	// rorx   $0x18,%ecx,%eax
	RORXL $0x18, CX, AX
	// rorx   $0x1a,%esi,%ebp
	RORXL $0x1a, SI, BP
	// xor    %eax,%edi
	XORL AX, DI
	// xor    %ebp,%edi
	XORL BP, DI
	// rorx   $0x1e,%edx,%eax
	RORXL $0x1e, DX, AX
	// xor    %edi,%eax
	XORL DI, AX
	// xor    %edx,%edx
	XORL DX, DX
	// div    %r15d
	DIVL R15
	// xor    %eax,%eax
	XORL AX, AX
	// shlx   %rbx,%rdx,%rdx
	SHLXQ BX, DX, DX
	// add    %r14,%rdx
	ADDQ R14, DX
	// add    $0x3,%bl
	ADDB $0x3, BL
	// bzhi   %ebx,%ecx,%edi
	BZHIL BX, CX, DI
	// movzwl %di,%ebp
	MOVWLZX DI, BP
	// and    $0x7,%dil
	ANDB $0x7, DIB
	// mov    $0x1,%r8d
	MOVL $0x1, R8
	// shlx   %edi,%r8d,%edi
	SHLXL DI, R8, DI
	// shr    $0x3,%rbp
	SHRQ $0x3, BP
	// movzbl 0x0(%rbp,%rdx,1),%ebp
	MOVBLZX (BP)(DX*1), BP
	// test   %ebp,%edi
	TESTL BP, DI
	// je     50f <PBF4_Test+0xef>
	JEQ L_pbf4_test_00ef
	// mov    $0xffffffff,%eax
	MOVL $0xffffffff, AX
	// shlx   %ebx,%eax,%eax
	SHLXL BX, AX, AX
	// not    %eax
	NOTL AX
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// shr    $0x10,%rdi
	SHRQ $0x10, DI
	// mov    %eax,%ebp
	MOVL AX, BP
	// and    %edi,%ebp
	ANDL DI, BP
	// movzwl %bp,%edi
	MOVWLZX BP, DI
	// and    $0x7,%bpl
	ANDB $0x7, BPB
	// shlx   %ebp,%r8d,%ebp
	SHLXL BP, R8, BP
	// shr    $0x3,%rdi
	SHRQ $0x3, DI
	// movzbl (%rdx,%rdi,1),%edi
	MOVBLZX (DX)(DI*1), DI
	// test   %ebp,%edi
	TESTL BP, DI
	// je     50d <PBF4_Test+0xed>
	JEQ L_pbf4_test_00ed
	// and    %eax,%esi
	ANDL AX, SI
	// mov    %esi,%ebp
	MOVL SI, BP
	// and    $0x7,%bpl
	ANDB $0x7, BPB
	// mov    $0x1,%edi
	MOVL $0x1, DI
	// shlx   %ebp,%edi,%ebp
	SHLXL BP, DI, BP
	// movzwl %si,%esi
	MOVWLZX SI, SI
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rdx,%rsi,1),%esi
	MOVBLZX (DX)(SI*1), SI
	// test   %ebp,%esi
	TESTL BP, SI
	// je     50d <PBF4_Test+0xed>
	JEQ L_pbf4_test_00ed
	// shr    $0x30,%rcx
	SHRQ $0x30, CX
	// and    %eax,%ecx
	ANDL AX, CX
	// mov    %ecx,%eax
	MOVL CX, AX
	// and    $0x7,%al
	ANDB $0x7, AL
	// shlx   %eax,%edi,%eax
	SHLXL AX, DI, AX
	// movzwl %cx,%ecx
	MOVWLZX CX, CX
	// shr    $0x3,%rcx
	SHRQ $0x3, CX
	// movzbl (%rdx,%rcx,1),%ecx
	MOVBLZX (DX)(CX*1), CX
	// test   %eax,%ecx
	TESTL AX, CX
	// setne  %al
	SETNE AL
	// jmp    50f <PBF4_Test+0xef>
	JMP L_pbf4_test_00ef
L_pbf4_test_00ed:
	// xor    %eax,%eax
	XORL AX, AX
L_pbf4_test_00ef:
	// add    $0x8,%rsp
	ADDQ $0x8, SP
	// pop    %rbx
	POPQ BX
	// pop    %r14
	POPQ R14
	// pop    %r15
	POPQ R15
	// pop    %rbp
	POPQ BP
	// ret
	RET

TEXT PBF5_Set(SB), NOSPLIT, $0
	// push   %rbp
	PUSHQ BP
	// push   %r15
	PUSHQ R15
	// push   %r14
	PUSHQ R14
	// push   %rbx
	PUSHQ BX
	// push   %rax
	SUBQ $8, SP
	// mov    %edx,%r15d
	MOVL DX, R15
	// mov    %esi,%ebx
	MOVL SI, BX
	// mov    %rdi,%r14
	MOVQ DI, R14
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// mov    %r8d,%esi
	MOVL R8, SI
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rsi
	MOVQ AX, SI
	// mov    %rdx,%r8
	MOVQ DX, R8
	// mov    %rsi,%rdi
	MOVQ SI, DI
	// shr    $0x20,%rdi
	SHRQ $0x20, DI
	// mov    %rdx,%rax
	MOVQ DX, AX
	// shr    $0x20,%rax
	SHRQ $0x20, AX
	// rorx   $0x18,%esi,%edx
	RORXL $0x18, SI, DX
	// rorx   $0x1a,%edi,%ecx
	RORXL $0x1a, DI, CX
	// rorx   $0x1c,%r8d,%ebp
	RORXL $0x1c, R8, BP
	// xor    %edx,%ebp
	XORL DX, BP
	// xor    %ecx,%ebp
	XORL CX, BP
	// rorx   $0x1e,%eax,%eax
	RORXL $0x1e, AX, AX
	// xor    %ebp,%eax
	XORL BP, AX
	// xor    %edx,%edx
	XORL DX, DX
	// div    %r15d
	DIVL R15
	// shlx   %rbx,%rdx,%rax
	SHLXQ BX, DX, AX
	// add    %r14,%rax
	ADDQ R14, AX
	// mov    %rsi,%r9
	MOVQ SI, R9
	// add    $0x3,%bl
	ADDB $0x3, BL
	// bzhi   %ebx,%esi,%ecx
	BZHIL BX, SI, CX
	// shr    $0x10,%rsi
	SHRQ $0x10, SI
	// shr    $0x30,%r9
	SHRQ $0x30, R9
	// movzwl %cx,%ebp
	MOVWLZX CX, BP
	// and    $0x7,%cl
	ANDB $0x7, CL
	// shr    $0x3,%rbp
	SHRQ $0x3, BP
	// movzbl 0x0(%rbp,%rax,1),%edx
	MOVBLZX (BP)(AX*1), DX
	// shrx   %ecx,%edx,%r10d
	SHRXL CX, DX, R10
	// bts    %ecx,%edx
	BTSL CX, DX
	// mov    %dl,0x0(%rbp,%rax,1)
	MOVB DL, (BP)(AX*1)
	// bzhi   %ebx,%esi,%ecx
	BZHIL BX, SI, CX
	// movzwl %cx,%edx
	MOVWLZX CX, DX
	// and    $0x7,%cl
	ANDB $0x7, CL
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%ebp
	MOVBLZX (DX)(AX*1), BP
	// shrx   %ecx,%ebp,%esi
	SHRXL CX, BP, SI
	// and    %r10d,%esi
	ANDL R10, SI
	// bts    %ecx,%ebp
	BTSL CX, BP
	// mov    %bpl,(%rdx,%rax,1)
	MOVB BPB, (DX)(AX*1)
	// bzhi   %ebx,%edi,%ecx
	BZHIL BX, DI, CX
	// movzwl %cx,%edx
	MOVWLZX CX, DX
	// and    $0x7,%cl
	ANDB $0x7, CL
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%edi
	MOVBLZX (DX)(AX*1), DI
	// shrx   %ecx,%edi,%r10d
	SHRXL CX, DI, R10
	// bts    %ecx,%edi
	BTSL CX, DI
	// mov    %dil,(%rdx,%rax,1)
	MOVB DIB, (DX)(AX*1)
	// bzhi   %ebx,%r9d,%ecx
	BZHIL BX, R9, CX
	// mov    %ecx,%edx
	MOVL CX, DX
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rcx
	SHRQ $0x3, CX
	// movzbl (%rcx,%rax,1),%edi
	MOVBLZX (CX)(AX*1), DI
	// shrx   %edx,%edi,%ebp
	SHRXL DX, DI, BP
	// and    %r10d,%ebp
	ANDL R10, BP
	// and    %esi,%ebp
	ANDL SI, BP
	// bts    %edx,%edi
	BTSL DX, DI
	// mov    %dil,(%rcx,%rax,1)
	MOVB DIB, (CX)(AX*1)
	// bzhi   %ebx,%r8d,%ecx
	BZHIL BX, R8, CX
	// movzwl %cx,%edx
	MOVWLZX CX, DX
	// and    $0x7,%cl
	ANDB $0x7, CL
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%esi
	MOVBLZX (DX)(AX*1), SI
	// shrx   %ecx,%esi,%edi
	SHRXL CX, SI, DI
	// and    %ebp,%edi
	ANDL BP, DI
	// bts    %ecx,%esi
	BTSL CX, SI
	// mov    %sil,(%rdx,%rax,1)
	MOVB SIB, (DX)(AX*1)
	// test   $0x1,%dil
	TESTB $0x1, DIB
	// sete   %al
	SETEQ AL
	// add    $0x8,%rsp
	ADDQ $0x8, SP
	// pop    %rbx
	POPQ BX
	// pop    %r14
	POPQ R14
	// pop    %r15
	POPQ R15
	// pop    %rbp
	POPQ BP
	// ret
	RET

TEXT PBF5_Test(SB), NOSPLIT, $0
	// push   %rbp
	PUSHQ BP
	// push   %r15
	PUSHQ R15
	// push   %r14
	PUSHQ R14
	// push   %rbx
	PUSHQ BX
	// push   %rax
	SUBQ $8, SP
	// mov    %edx,%r15d
	MOVL DX, R15
	// mov    %esi,%ebx
	MOVL SI, BX
	// mov    %rdi,%r14
	MOVQ DI, R14
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// mov    %r8d,%esi
	MOVL R8, SI
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	MOVQ AX, CX
	// mov    %rdx,%rbp
	MOVQ DX, BP
	// rorx   $0x18,%ecx,%eax
	RORXL $0x18, CX, AX
	// mov    %rcx,%rdx
	MOVQ CX, DX
	// shr    $0x20,%rdx
	SHRQ $0x20, DX
	// rorx   $0x1c,%ebp,%edi
	RORXL $0x1c, BP, DI
	// mov    %rbp,%rsi
	MOVQ BP, SI
	// shr    $0x20,%rsi
	SHRQ $0x20, SI
	// rorx   $0x1a,%edx,%edx
	RORXL $0x1a, DX, DX
	// xor    %eax,%edi
	XORL AX, DI
	// xor    %edx,%edi
	XORL DX, DI
	// rorx   $0x1e,%esi,%eax
	RORXL $0x1e, SI, AX
	// xor    %edi,%eax
	XORL DI, AX
	// xor    %edx,%edx
	XORL DX, DX
	// div    %r15d
	DIVL R15
	// vmovq  %rbp,%xmm0
	VMOVQ BP, X0
	// vmovq  %rcx,%xmm1
	VMOVQ CX, X1
	// shlx   %rbx,%rdx,%rax
	SHLXQ BX, DX, AX
	// add    %r14,%rax
	ADDQ R14, AX
	// vpunpcklqdq %xmm0,%xmm1,%xmm0
	VPUNPCKLQDQ X0, X1, X0
	// add    $0x3,%bl
	ADDB $0x3, BL
	// mov    $0xffffffff,%ecx
	MOVL $0xffffffff, CX
	// shlx   %ebx,%ecx,%ecx
	SHLXL BX, CX, CX
	// not    %ecx
	NOTL CX
	// vmovd  %ecx,%xmm1
	VMOVD CX, X1
	// vpbroadcastd %xmm1,%ymm1
	VPBROADCASTD X1, Y1
	// vpsrld $0x10,%xmm0,%xmm2
	VPSRLD $0x10, X0, X2
	// vinserti128 $0x1,%xmm2,%ymm0,%ymm0
	VINSERTI128 $0x1, X2, Y0, Y0
	// vpand  %ymm0,%ymm1,%ymm0
	VPAND Y0, Y1, Y0
	// vpsrld $0x5,%ymm0,%ymm1
	VPSRLD $0x5, Y0, Y1
	// vmovdqa 0x45(%rip),%ymm2        # 720 <PBF5_Test+0xe0>
	VMOVDQA pbf5_test_vec<>(SB), Y2
	// vpcmpeqd %ymm3,%ymm3,%ymm3
	VPCMPEQD Y3, Y3, Y3
	// vpgatherdd %ymm2,(%rax,%ymm1,4),%ymm3
	VPGATHERDD Y2, (AX)(Y1*4), Y3
	// vpbroadcastd 0x52(%rip),%ymm1        # 740 <PBF5_Test+0x100>
	VPBROADCASTD pbf5_test_mask31<>(SB), Y1
	// vpand  %ymm1,%ymm0,%ymm0
	VPAND Y1, Y0, Y0
	// vpbroadcastd 0x49(%rip),%ymm1        # 744 <PBF5_Test+0x104>
	VPBROADCASTD pbf5_test_one<>(SB), Y1
	// vpsllvd %ymm0,%ymm1,%ymm0
	VPSLLVD Y0, Y1, Y0
	// vpandn %ymm0,%ymm3,%ymm1
	VPANDN Y0, Y3, Y1
	// vptest %ymm0,%ymm1
	VPTEST Y0, Y1
	// sete   %al
	SETEQ AL
	// add    $0x8,%rsp
	ADDQ $0x8, SP
	// pop    %rbx
	POPQ BX
	// pop    %r14
	POPQ R14
	// pop    %r15
	POPQ R15
	// pop    %rbp
	POPQ BP
	// vzeroupper
	VZEROUPPER
	// ret
	RET

TEXT PBF6_Set(SB), NOSPLIT, $0
	// push   %rbp
	PUSHQ BP
	// push   %r15
	PUSHQ R15
	// push   %r14
	PUSHQ R14
	// push   %r12
	PUSHQ R12
	// push   %rbx
	PUSHQ BX
	// mov    %edx,%r15d
	MOVL DX, R15
	// mov    %esi,%r12d
	MOVL SI, R12
	// mov    %rdi,%r14
	MOVQ DI, R14
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// mov    %r8d,%esi
	MOVL R8, SI
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rsi
	MOVQ AX, SI
	// mov    %rdx,%rcx
	MOVQ DX, CX
	// mov    %rax,%r8
	MOVQ AX, R8
	// shr    $0x20,%r8
	SHRQ $0x20, R8
	// mov    %rdx,%rax
	MOVQ DX, AX
	// shr    $0x20,%rax
	SHRQ $0x20, AX
	// rorx   $0x18,%esi,%edx
	RORXL $0x18, SI, DX
	// rorx   $0x1a,%r8d,%edi
	RORXL $0x1a, R8, DI
	// rorx   $0x1c,%ecx,%ebp
	RORXL $0x1c, CX, BP
	// xor    %edx,%ebp
	XORL DX, BP
	// xor    %edi,%ebp
	XORL DI, BP
	// rorx   $0x1e,%eax,%eax
	RORXL $0x1e, AX, AX
	// xor    %ebp,%eax
	XORL BP, AX
	// xor    %edx,%edx
	XORL DX, DX
	// div    %r15d
	DIVL R15
	// shlx   %r12,%rdx,%rax
	SHLXQ R12, DX, AX
	// add    %r14,%rax
	ADDQ R14, AX
	// mov    %rsi,%r10
	MOVQ SI, R10
	// add    $0x3,%r12b
	ADDB $0x3, R12B
	// bzhi   %r12d,%esi,%r9d
	BZHIL R12, SI, R9
	// shr    $0x10,%rsi
	SHRQ $0x10, SI
	// shr    $0x30,%r10
	SHRQ $0x30, R10
	// bzhi   %r12d,%ecx,%r11d
	BZHIL R12, CX, R11
	// shr    $0x10,%rcx
	SHRQ $0x10, CX
	// movzwl %r9w,%ebp
	MOVWLZX R9, BP
	// mov    %r9d,%edx
	MOVL R9, DX
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rbp
	SHRQ $0x3, BP
	// movzbl 0x0(%rbp,%rax,1),%ebx
	MOVBLZX (BP)(AX*1), BX
	// shrx   %edx,%ebx,%edi
	SHRXL DX, BX, DI
	// bts    %edx,%ebx
	BTSL DX, BX
	// mov    %bl,0x0(%rbp,%rax,1)
	MOVB BL, (BP)(AX*1)
	// bzhi   %r12d,%esi,%edx
	BZHIL R12, SI, DX
	// movzwl %dx,%esi
	MOVWLZX DX, SI
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%ebp
	MOVBLZX (SI)(AX*1), BP
	// shrx   %edx,%ebp,%ebx
	SHRXL DX, BP, BX
	// and    %edi,%ebx
	ANDL DI, BX
	// bts    %edx,%ebp
	BTSL DX, BP
	// mov    %bpl,(%rsi,%rax,1)
	MOVB BPB, (SI)(AX*1)
	// bzhi   %r12d,%r8d,%edx
	BZHIL R12, R8, DX
	// movzwl %dx,%esi
	MOVWLZX DX, SI
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%edi
	MOVBLZX (SI)(AX*1), DI
	// shrx   %edx,%edi,%r8d
	SHRXL DX, DI, R8
	// bts    %edx,%edi
	BTSL DX, DI
	// mov    %dil,(%rsi,%rax,1)
	MOVB DIB, (SI)(AX*1)
	// bzhi   %r12d,%r10d,%edx
	BZHIL R12, R10, DX
	// mov    %edx,%esi
	MOVL DX, SI
	// and    $0x7,%sil
	ANDB $0x7, SIB
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%edi
	MOVBLZX (DX)(AX*1), DI
	// shrx   %esi,%edi,%ebp
	SHRXL SI, DI, BP
	// and    %r8d,%ebp
	ANDL R8, BP
	// and    %ebx,%ebp
	ANDL BX, BP
	// bts    %esi,%edi
	BTSL SI, DI
	// mov    %dil,(%rdx,%rax,1)
	MOVB DIB, (DX)(AX*1)
	// movzwl %r11w,%edx
	MOVWLZX R11, DX
	// mov    %r11d,%esi
	MOVL R11, SI
	// and    $0x7,%sil
	ANDB $0x7, SIB
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%edi
	MOVBLZX (DX)(AX*1), DI
	// shrx   %esi,%edi,%ebx
	SHRXL SI, DI, BX
	// bts    %esi,%edi
	BTSL SI, DI
	// mov    %dil,(%rdx,%rax,1)
	MOVB DIB, (DX)(AX*1)
	// bzhi   %r12d,%ecx,%ecx
	BZHIL R12, CX, CX
	// movzwl %cx,%edx
	MOVWLZX CX, DX
	// and    $0x7,%cl
	ANDB $0x7, CL
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%esi
	MOVBLZX (DX)(AX*1), SI
	// shrx   %ecx,%esi,%edi
	SHRXL CX, SI, DI
	// and    %ebx,%edi
	ANDL BX, DI
	// and    %ebp,%edi
	ANDL BP, DI
	// bts    %ecx,%esi
	BTSL CX, SI
	// mov    %sil,(%rdx,%rax,1)
	MOVB SIB, (DX)(AX*1)
	// test   $0x1,%dil
	TESTB $0x1, DIB
	// sete   %al
	SETEQ AL
	// pop    %rbx
	POPQ BX
	// pop    %r12
	POPQ R12
	// pop    %r14
	POPQ R14
	// pop    %r15
	POPQ R15
	// pop    %rbp
	POPQ BP
	// ret
	RET

TEXT PBF6_Test(SB), NOSPLIT, $0
	// push   %rbp
	PUSHQ BP
	// push   %r15
	PUSHQ R15
	// push   %r14
	PUSHQ R14
	// push   %rbx
	PUSHQ BX
	// push   %rax
	SUBQ $8, SP
	// mov    %edx,%r15d
	MOVL DX, R15
	// mov    %esi,%ebx
	MOVL SI, BX
	// mov    %rdi,%r14
	MOVQ DI, R14
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// mov    %r8d,%esi
	MOVL R8, SI
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	MOVQ AX, CX
	// mov    %rdx,%rbp
	MOVQ DX, BP
	// rorx   $0x18,%ecx,%eax
	RORXL $0x18, CX, AX
	// mov    %rcx,%rdx
	MOVQ CX, DX
	// shr    $0x20,%rdx
	SHRQ $0x20, DX
	// rorx   $0x1c,%ebp,%edi
	RORXL $0x1c, BP, DI
	// mov    %rbp,%rsi
	MOVQ BP, SI
	// shr    $0x20,%rsi
	SHRQ $0x20, SI
	// rorx   $0x1a,%edx,%edx
	RORXL $0x1a, DX, DX
	// xor    %eax,%edi
	XORL AX, DI
	// xor    %edx,%edi
	XORL DX, DI
	// rorx   $0x1e,%esi,%eax
	RORXL $0x1e, SI, AX
	// xor    %edi,%eax
	XORL DI, AX
	// xor    %edx,%edx
	XORL DX, DX
	// div    %r15d
	DIVL R15
	// vmovq  %rbp,%xmm0
	VMOVQ BP, X0
	// vmovq  %rcx,%xmm1
	VMOVQ CX, X1
	// shlx   %rbx,%rdx,%rax
	SHLXQ BX, DX, AX
	// add    %r14,%rax
	ADDQ R14, AX
	// vpunpcklqdq %xmm0,%xmm1,%xmm0
	VPUNPCKLQDQ X0, X1, X0
	// add    $0x3,%bl
	ADDB $0x3, BL
	// mov    $0xffffffff,%ecx
	MOVL $0xffffffff, CX
	// shlx   %ebx,%ecx,%ecx
	SHLXL BX, CX, CX
	// not    %ecx
	NOTL CX
	// vmovd  %ecx,%xmm1
	VMOVD CX, X1
	// vpbroadcastd %xmm1,%ymm1
	VPBROADCASTD X1, Y1
	// vpsrld $0x10,%xmm0,%xmm2
	VPSRLD $0x10, X0, X2
	// vinserti128 $0x1,%xmm2,%ymm0,%ymm0
	VINSERTI128 $0x1, X2, Y0, Y0
	// vpand  %ymm0,%ymm1,%ymm0
	VPAND Y0, Y1, Y0
	// vpsrld $0x5,%ymm0,%ymm1
	VPSRLD $0x5, Y0, Y1
	// vmovdqa 0x45(%rip),%ymm2        # 9a0 <PBF6_Test+0xe0>
	VMOVDQA pbf6_test_vec<>(SB), Y2
	// vpcmpeqd %ymm3,%ymm3,%ymm3
	VPCMPEQD Y3, Y3, Y3
	// vpgatherdd %ymm2,(%rax,%ymm1,4),%ymm3
	VPGATHERDD Y2, (AX)(Y1*4), Y3
	// vpbroadcastd 0x52(%rip),%ymm1        # 9c0 <PBF6_Test+0x100>
	VPBROADCASTD pbf6_test_mask31<>(SB), Y1
	// vpand  %ymm1,%ymm0,%ymm0
	VPAND Y1, Y0, Y0
	// vpbroadcastd 0x49(%rip),%ymm1        # 9c4 <PBF6_Test+0x104>
	VPBROADCASTD pbf6_test_one<>(SB), Y1
	// vpsllvd %ymm0,%ymm1,%ymm0
	VPSLLVD Y0, Y1, Y0
	// vpandn %ymm0,%ymm3,%ymm1
	VPANDN Y0, Y3, Y1
	// vptest %ymm0,%ymm1
	VPTEST Y0, Y1
	// sete   %al
	SETEQ AL
	// add    $0x8,%rsp
	ADDQ $0x8, SP
	// pop    %rbx
	POPQ BX
	// pop    %r14
	POPQ R14
	// pop    %r15
	POPQ R15
	// pop    %rbp
	POPQ BP
	// vzeroupper
	VZEROUPPER
	// ret
	RET

TEXT PBF7_Set(SB), NOSPLIT, $0
	// push   %rbp
	PUSHQ BP
	// push   %r15
	PUSHQ R15
	// push   %r14
	PUSHQ R14
	// push   %rbx
	PUSHQ BX
	// push   %rax
	SUBQ $8, SP
	// mov    %edx,%ebp
	MOVL DX, BP
	// mov    %esi,%r15d
	MOVL SI, R15
	// mov    %rdi,%r14
	MOVQ DI, R14
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// mov    %r8d,%esi
	MOVL R8, SI
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rsi
	MOVQ AX, SI
	// mov    %rdx,%rcx
	MOVQ DX, CX
	// mov    %rax,%r9
	MOVQ AX, R9
	// shr    $0x20,%r9
	SHRQ $0x20, R9
	// mov    %rdx,%r8
	MOVQ DX, R8
	// shr    $0x20,%r8
	SHRQ $0x20, R8
	// rorx   $0x18,%esi,%eax
	RORXL $0x18, SI, AX
	// rorx   $0x1a,%r9d,%edx
	RORXL $0x1a, R9, DX
	// rorx   $0x1c,%ecx,%edi
	RORXL $0x1c, CX, DI
	// xor    %eax,%edi
	XORL AX, DI
	// xor    %edx,%edi
	XORL DX, DI
	// rorx   $0x1e,%r8d,%eax
	RORXL $0x1e, R8, AX
	// xor    %edi,%eax
	XORL DI, AX
	// xor    %edx,%edx
	XORL DX, DX
	// div    %ebp
	DIVL BP
	// shlx   %r15,%rdx,%rax
	SHLXQ R15, DX, AX
	// add    %r14,%rax
	ADDQ R14, AX
	// mov    %rsi,%r11
	MOVQ SI, R11
	// add    $0x3,%r15b
	ADDB $0x3, R15B
	// bzhi   %r15d,%esi,%r10d
	BZHIL R15, SI, R10
	// shr    $0x10,%rsi
	SHRQ $0x10, SI
	// shr    $0x30,%r11
	SHRQ $0x30, R11
	// bzhi   %r15d,%ecx,%r14d
	BZHIL R15, CX, R14
	// mov    %rcx,%rbp
	MOVQ CX, BP
	// shr    $0x10,%rbp
	SHRQ $0x10, BP
	// movzwl %r10w,%ecx
	MOVWLZX R10, CX
	// mov    %r10d,%edx
	MOVL R10, DX
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rcx
	SHRQ $0x3, CX
	// movzbl (%rcx,%rax,1),%ebx
	MOVBLZX (CX)(AX*1), BX
	// shrx   %edx,%ebx,%edi
	SHRXL DX, BX, DI
	// bts    %edx,%ebx
	BTSL DX, BX
	// mov    %bl,(%rcx,%rax,1)
	MOVB BL, (CX)(AX*1)
	// bzhi   %r15d,%esi,%ecx
	BZHIL R15, SI, CX
	// movzwl %cx,%edx
	MOVWLZX CX, DX
	// and    $0x7,%cl
	ANDB $0x7, CL
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%esi
	MOVBLZX (DX)(AX*1), SI
	// shrx   %ecx,%esi,%ebx
	SHRXL CX, SI, BX
	// and    %edi,%ebx
	ANDL DI, BX
	// bts    %ecx,%esi
	BTSL CX, SI
	// mov    %sil,(%rdx,%rax,1)
	MOVB SIB, (DX)(AX*1)
	// bzhi   %r15d,%r9d,%ecx
	BZHIL R15, R9, CX
	// movzwl %cx,%edx
	MOVWLZX CX, DX
	// and    $0x7,%cl
	ANDB $0x7, CL
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%esi
	MOVBLZX (DX)(AX*1), SI
	// shrx   %ecx,%esi,%r9d
	SHRXL CX, SI, R9
	// bts    %ecx,%esi
	BTSL CX, SI
	// mov    %sil,(%rdx,%rax,1)
	MOVB SIB, (DX)(AX*1)
	// bzhi   %r15d,%r11d,%edx
	BZHIL R15, R11, DX
	// mov    %edx,%esi
	MOVL DX, SI
	// and    $0x7,%sil
	ANDB $0x7, SIB
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%edi
	MOVBLZX (DX)(AX*1), DI
	// shrx   %esi,%edi,%ecx
	SHRXL SI, DI, CX
	// and    %r9d,%ecx
	ANDL R9, CX
	// and    %ebx,%ecx
	ANDL BX, CX
	// bts    %esi,%edi
	BTSL SI, DI
	// mov    %dil,(%rdx,%rax,1)
	MOVB DIB, (DX)(AX*1)
	// movzwl %r14w,%edx
	MOVWLZX R14, DX
	// mov    %r14d,%esi
	MOVL R14, SI
	// and    $0x7,%sil
	ANDB $0x7, SIB
	// shr    $0x3,%rdx
	SHRQ $0x3, DX
	// movzbl (%rdx,%rax,1),%edi
	MOVBLZX (DX)(AX*1), DI
	// shrx   %esi,%edi,%ebx
	SHRXL SI, DI, BX
	// bts    %esi,%edi
	BTSL SI, DI
	// mov    %dil,(%rdx,%rax,1)
	MOVB DIB, (DX)(AX*1)
	// bzhi   %r15d,%ebp,%edx
	BZHIL R15, BP, DX
	// movzwl %dx,%esi
	MOVWLZX DX, SI
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%edi
	MOVBLZX (SI)(AX*1), DI
	// shrx   %edx,%edi,%ebp
	SHRXL DX, DI, BP
	// and    %ebx,%ebp
	ANDL BX, BP
	// bts    %edx,%edi
	BTSL DX, DI
	// mov    %dil,(%rsi,%rax,1)
	MOVB DIB, (SI)(AX*1)
	// bzhi   %r15d,%r8d,%edx
	BZHIL R15, R8, DX
	// movzwl %dx,%esi
	MOVWLZX DX, SI
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%edi
	MOVBLZX (SI)(AX*1), DI
	// shrx   %edx,%edi,%ebx
	SHRXL DX, DI, BX
	// and    %ebp,%ebx
	ANDL BP, BX
	// and    %ecx,%ebx
	ANDL CX, BX
	// bts    %edx,%edi
	BTSL DX, DI
	// mov    %dil,(%rsi,%rax,1)
	MOVB DIB, (SI)(AX*1)
	// test   $0x1,%bl
	TESTB $0x1, BL
	// sete   %al
	SETEQ AL
	// add    $0x8,%rsp
	ADDQ $0x8, SP
	// pop    %rbx
	POPQ BX
	// pop    %r14
	POPQ R14
	// pop    %r15
	POPQ R15
	// pop    %rbp
	POPQ BP
	// ret
	RET

TEXT PBF7_Test(SB), NOSPLIT, $0
	// push   %rbp
	PUSHQ BP
	// push   %r15
	PUSHQ R15
	// push   %r14
	PUSHQ R14
	// push   %rbx
	PUSHQ BX
	// push   %rax
	SUBQ $8, SP
	// mov    %edx,%r15d
	MOVL DX, R15
	// mov    %esi,%ebx
	MOVL SI, BX
	// mov    %rdi,%r14
	MOVQ DI, R14
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// mov    %r8d,%esi
	MOVL R8, SI
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	MOVQ AX, CX
	// mov    %rdx,%rbp
	MOVQ DX, BP
	// rorx   $0x18,%ecx,%eax
	RORXL $0x18, CX, AX
	// mov    %rcx,%rdx
	MOVQ CX, DX
	// shr    $0x20,%rdx
	SHRQ $0x20, DX
	// rorx   $0x1c,%ebp,%edi
	RORXL $0x1c, BP, DI
	// mov    %rbp,%rsi
	MOVQ BP, SI
	// shr    $0x20,%rsi
	SHRQ $0x20, SI
	// rorx   $0x1a,%edx,%edx
	RORXL $0x1a, DX, DX
	// xor    %eax,%edi
	XORL AX, DI
	// xor    %edx,%edi
	XORL DX, DI
	// rorx   $0x1e,%esi,%eax
	RORXL $0x1e, SI, AX
	// xor    %edi,%eax
	XORL DI, AX
	// xor    %edx,%edx
	XORL DX, DX
	// div    %r15d
	DIVL R15
	// vmovq  %rbp,%xmm0
	VMOVQ BP, X0
	// vmovq  %rcx,%xmm1
	VMOVQ CX, X1
	// shlx   %rbx,%rdx,%rax
	SHLXQ BX, DX, AX
	// add    %r14,%rax
	ADDQ R14, AX
	// vpunpcklqdq %xmm0,%xmm1,%xmm0
	VPUNPCKLQDQ X0, X1, X0
	// add    $0x3,%bl
	ADDB $0x3, BL
	// mov    $0xffffffff,%ecx
	MOVL $0xffffffff, CX
	// shlx   %ebx,%ecx,%ecx
	SHLXL BX, CX, CX
	// not    %ecx
	NOTL CX
	// vmovd  %ecx,%xmm1
	VMOVD CX, X1
	// vpbroadcastd %xmm1,%ymm1
	VPBROADCASTD X1, Y1
	// vpsrld $0x10,%xmm0,%xmm2
	VPSRLD $0x10, X0, X2
	// vinserti128 $0x1,%xmm2,%ymm0,%ymm0
	VINSERTI128 $0x1, X2, Y0, Y0
	// vpand  %ymm0,%ymm1,%ymm0
	VPAND Y0, Y1, Y0
	// vpsrld $0x5,%ymm0,%ymm1
	VPSRLD $0x5, Y0, Y1
	// vmovdqa 0x45(%rip),%ymm2        # c40 <PBF7_Test+0xe0>
	VMOVDQA pbf7_test_vec<>(SB), Y2
	// vpcmpeqd %ymm3,%ymm3,%ymm3
	VPCMPEQD Y3, Y3, Y3
	// vpgatherdd %ymm2,(%rax,%ymm1,4),%ymm3
	VPGATHERDD Y2, (AX)(Y1*4), Y3
	// vpbroadcastd 0x52(%rip),%ymm1        # c60 <PBF7_Test+0x100>
	VPBROADCASTD pbf7_test_mask31<>(SB), Y1
	// vpand  %ymm1,%ymm0,%ymm0
	VPAND Y1, Y0, Y0
	// vpbroadcastd 0x49(%rip),%ymm1        # c64 <PBF7_Test+0x104>
	VPBROADCASTD pbf7_test_one<>(SB), Y1
	// vpsllvd %ymm0,%ymm1,%ymm0
	VPSLLVD Y0, Y1, Y0
	// vpandn %ymm0,%ymm3,%ymm1
	VPANDN Y0, Y3, Y1
	// vptest %ymm0,%ymm1
	VPTEST Y0, Y1
	// sete   %al
	SETEQ AL
	// add    $0x8,%rsp
	ADDQ $0x8, SP
	// pop    %rbx
	POPQ BX
	// pop    %r14
	POPQ R14
	// pop    %r15
	POPQ R15
	// pop    %rbp
	POPQ BP
	// vzeroupper
	VZEROUPPER
	// ret
	RET

TEXT PBF8_Set(SB), NOSPLIT, $0
	// push   %rbp
	PUSHQ BP
	// push   %r15
	PUSHQ R15
	// push   %r14
	PUSHQ R14
	// push   %r12
	PUSHQ R12
	// push   %rbx
	PUSHQ BX
	// mov    %edx,%ebp
	MOVL DX, BP
	// mov    %esi,%r15d
	MOVL SI, R15
	// mov    %rdi,%r14
	MOVQ DI, R14
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// mov    %r8d,%esi
	MOVL R8, SI
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rsi
	MOVQ AX, SI
	// mov    %rdx,%rcx
	MOVQ DX, CX
	// mov    %rax,%r10
	MOVQ AX, R10
	// shr    $0x20,%r10
	SHRQ $0x20, R10
	// mov    %rdx,%r8
	MOVQ DX, R8
	// shr    $0x20,%r8
	SHRQ $0x20, R8
	// rorx   $0x18,%esi,%eax
	RORXL $0x18, SI, AX
	// rorx   $0x1a,%r10d,%edx
	RORXL $0x1a, R10, DX
	// rorx   $0x1c,%ecx,%edi
	RORXL $0x1c, CX, DI
	// xor    %eax,%edi
	XORL AX, DI
	// xor    %edx,%edi
	XORL DX, DI
	// rorx   $0x1e,%r8d,%eax
	RORXL $0x1e, R8, AX
	// xor    %edi,%eax
	XORL DI, AX
	// xor    %edx,%edx
	XORL DX, DX
	// div    %ebp
	DIVL BP
	// shlx   %r15,%rdx,%rax
	SHLXQ R15, DX, AX
	// add    %r14,%rax
	ADDQ R14, AX
	// mov    %rsi,%r14
	MOVQ SI, R14
	// add    $0x3,%r15b
	ADDB $0x3, R15B
	// bzhi   %r15d,%esi,%r11d
	BZHIL R15, SI, R11
	// shr    $0x10,%rsi
	SHRQ $0x10, SI
	// shr    $0x30,%r14
	SHRQ $0x30, R14
	// mov    %rcx,%r9
	MOVQ CX, R9
	// bzhi   %r15d,%ecx,%r12d
	BZHIL R15, CX, R12
	// mov    %rcx,%rdx
	MOVQ CX, DX
	// shr    $0x10,%rdx
	SHRQ $0x10, DX
	// shr    $0x30,%r9
	SHRQ $0x30, R9
	// movzwl %r11w,%ecx
	MOVWLZX R11, CX
	// mov    %r11d,%ebp
	MOVL R11, BP
	// and    $0x7,%bpl
	ANDB $0x7, BPB
	// shr    $0x3,%rcx
	SHRQ $0x3, CX
	// movzbl (%rcx,%rax,1),%ebx
	MOVBLZX (CX)(AX*1), BX
	// shrx   %ebp,%ebx,%edi
	SHRXL BP, BX, DI
	// bts    %ebp,%ebx
	BTSL BP, BX
	// mov    %bl,(%rcx,%rax,1)
	MOVB BL, (CX)(AX*1)
	// bzhi   %r15d,%esi,%ecx
	BZHIL R15, SI, CX
	// movzwl %cx,%esi
	MOVWLZX CX, SI
	// and    $0x7,%cl
	ANDB $0x7, CL
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%ebp
	MOVBLZX (SI)(AX*1), BP
	// shrx   %ecx,%ebp,%ebx
	SHRXL CX, BP, BX
	// and    %edi,%ebx
	ANDL DI, BX
	// bts    %ecx,%ebp
	BTSL CX, BP
	// mov    %bpl,(%rsi,%rax,1)
	MOVB BPB, (SI)(AX*1)
	// bzhi   %r15d,%r10d,%ecx
	BZHIL R15, R10, CX
	// movzwl %cx,%esi
	MOVWLZX CX, SI
	// and    $0x7,%cl
	ANDB $0x7, CL
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%edi
	MOVBLZX (SI)(AX*1), DI
	// shrx   %ecx,%edi,%r10d
	SHRXL CX, DI, R10
	// bts    %ecx,%edi
	BTSL CX, DI
	// mov    %dil,(%rsi,%rax,1)
	MOVB DIB, (SI)(AX*1)
	// bzhi   %r15d,%r14d,%esi
	BZHIL R15, R14, SI
	// mov    %esi,%edi
	MOVL SI, DI
	// and    $0x7,%dil
	ANDB $0x7, DIB
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%ebp
	MOVBLZX (SI)(AX*1), BP
	// shrx   %edi,%ebp,%ecx
	SHRXL DI, BP, CX
	// and    %r10d,%ecx
	ANDL R10, CX
	// and    %ebx,%ecx
	ANDL BX, CX
	// bts    %edi,%ebp
	BTSL DI, BP
	// mov    %bpl,(%rsi,%rax,1)
	MOVB BPB, (SI)(AX*1)
	// movzwl %r12w,%esi
	MOVWLZX R12, SI
	// mov    %r12d,%edi
	MOVL R12, DI
	// and    $0x7,%dil
	ANDB $0x7, DIB
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%ebp
	MOVBLZX (SI)(AX*1), BP
	// shrx   %edi,%ebp,%ebx
	SHRXL DI, BP, BX
	// bts    %edi,%ebp
	BTSL DI, BP
	// mov    %bpl,(%rsi,%rax,1)
	MOVB BPB, (SI)(AX*1)
	// bzhi   %r15d,%edx,%edx
	BZHIL R15, DX, DX
	// movzwl %dx,%esi
	MOVWLZX DX, SI
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%edi
	MOVBLZX (SI)(AX*1), DI
	// shrx   %edx,%edi,%ebp
	SHRXL DX, DI, BP
	// and    %ebx,%ebp
	ANDL BX, BP
	// bts    %edx,%edi
	BTSL DX, DI
	// mov    %dil,(%rsi,%rax,1)
	MOVB DIB, (SI)(AX*1)
	// bzhi   %r15d,%r8d,%edx
	BZHIL R15, R8, DX
	// movzwl %dx,%esi
	MOVWLZX DX, SI
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rsi
	SHRQ $0x3, SI
	// movzbl (%rsi,%rax,1),%edi
	MOVBLZX (SI)(AX*1), DI
	// shrx   %edx,%edi,%ebx
	SHRXL DX, DI, BX
	// and    %ebp,%ebx
	ANDL BP, BX
	// and    %ecx,%ebx
	ANDL CX, BX
	// bts    %edx,%edi
	BTSL DX, DI
	// mov    %dil,(%rsi,%rax,1)
	MOVB DIB, (SI)(AX*1)
	// bzhi   %r15d,%r9d,%ecx
	BZHIL R15, R9, CX
	// mov    %ecx,%edx
	MOVL CX, DX
	// and    $0x7,%dl
	ANDB $0x7, DL
	// shr    $0x3,%rcx
	SHRQ $0x3, CX
	// movzbl (%rcx,%rax,1),%esi
	MOVBLZX (CX)(AX*1), SI
	// shrx   %edx,%esi,%edi
	SHRXL DX, SI, DI
	// and    %ebx,%edi
	ANDL BX, DI
	// bts    %edx,%esi
	BTSL DX, SI
	// mov    %sil,(%rcx,%rax,1)
	MOVB SIB, (CX)(AX*1)
	// test   $0x1,%dil
	TESTB $0x1, DIB
	// sete   %al
	SETEQ AL
	// pop    %rbx
	POPQ BX
	// pop    %r12
	POPQ R12
	// pop    %r14
	POPQ R14
	// pop    %r15
	POPQ R15
	// pop    %rbp
	POPQ BP
	// ret
	RET

TEXT PBF8_Test(SB), NOSPLIT, $0
	// push   %rbp
	PUSHQ BP
	// push   %r15
	PUSHQ R15
	// push   %r14
	PUSHQ R14
	// push   %rbx
	PUSHQ BX
	// push   %rax
	SUBQ $8, SP
	// mov    %edx,%r15d
	MOVL DX, R15
	// mov    %esi,%ebx
	MOVL SI, BX
	// mov    %rdi,%r14
	MOVQ DI, R14
	// mov    %rcx,%rdi
	MOVQ CX, DI
	// mov    %r8d,%esi
	MOVL R8, SI
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	MOVQ AX, CX
	// mov    %rdx,%rbp
	MOVQ DX, BP
	// rorx   $0x18,%ecx,%eax
	RORXL $0x18, CX, AX
	// mov    %rcx,%rdx
	MOVQ CX, DX
	// shr    $0x20,%rdx
	SHRQ $0x20, DX
	// rorx   $0x1c,%ebp,%edi
	RORXL $0x1c, BP, DI
	// mov    %rbp,%rsi
	MOVQ BP, SI
	// shr    $0x20,%rsi
	SHRQ $0x20, SI
	// rorx   $0x1a,%edx,%edx
	RORXL $0x1a, DX, DX
	// xor    %eax,%edi
	XORL AX, DI
	// xor    %edx,%edi
	XORL DX, DI
	// rorx   $0x1e,%esi,%eax
	RORXL $0x1e, SI, AX
	// xor    %edi,%eax
	XORL DI, AX
	// xor    %edx,%edx
	XORL DX, DX
	// div    %r15d
	DIVL R15
	// vmovq  %rbp,%xmm0
	VMOVQ BP, X0
	// vmovq  %rcx,%xmm1
	VMOVQ CX, X1
	// shlx   %rbx,%rdx,%rax
	SHLXQ BX, DX, AX
	// add    %r14,%rax
	ADDQ R14, AX
	// vpunpcklqdq %xmm0,%xmm1,%xmm0
	VPUNPCKLQDQ X0, X1, X0
	// add    $0x3,%bl
	ADDB $0x3, BL
	// mov    $0xffffffff,%ecx
	MOVL $0xffffffff, CX
	// shlx   %ebx,%ecx,%ecx
	SHLXL BX, CX, CX
	// not    %ecx
	NOTL CX
	// vmovd  %ecx,%xmm1
	VMOVD CX, X1
	// vpbroadcastd %xmm1,%ymm1
	VPBROADCASTD X1, Y1
	// vpsrld $0x10,%xmm0,%xmm2
	VPSRLD $0x10, X0, X2
	// vinserti128 $0x1,%xmm2,%ymm0,%ymm0
	VINSERTI128 $0x1, X2, Y0, Y0
	// vpand  %ymm0,%ymm1,%ymm0
	VPAND Y0, Y1, Y0
	// vpsrld $0x5,%ymm0,%ymm1
	VPSRLD $0x5, Y0, Y1
	// vpcmpeqd %ymm2,%ymm2,%ymm2
	VPCMPEQD Y2, Y2, Y2
	// vpxor  %xmm3,%xmm3,%xmm3
	VPXOR X3, X3, X3
	// vpgatherdd %ymm2,(%rax,%ymm1,4),%ymm3
	VPGATHERDD Y2, (AX)(Y1*4), Y3
	// vpbroadcastd 0x2e(%rip),%ymm1        # ef8 <PBF8_Test+0xd8>
	VPBROADCASTD pbf8_test_mask31<>(SB), Y1
	// vpand  %ymm1,%ymm0,%ymm0
	VPAND Y1, Y0, Y0
	// vpbroadcastd 0x25(%rip),%ymm1        # efc <PBF8_Test+0xdc>
	VPBROADCASTD pbf8_test_one<>(SB), Y1
	// vpsllvd %ymm0,%ymm1,%ymm0
	VPSLLVD Y0, Y1, Y0
	// vpandn %ymm0,%ymm3,%ymm1
	VPANDN Y0, Y3, Y1
	// vptest %ymm0,%ymm1
	VPTEST Y0, Y1
	// sete   %al
	SETEQ AL
	// add    $0x8,%rsp
	ADDQ $0x8, SP
	// pop    %rbx
	POPQ BX
	// pop    %r14
	POPQ R14
	// pop    %r15
	POPQ R15
	// pop    %rbp
	POPQ BP
	// vzeroupper
	VZEROUPPER
	// ret
	RET
