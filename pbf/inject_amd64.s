#include "textflag.h"

TEXT _ZN3pbf4HashEPKhj(SB), NOSPLIT, $0
	// movabs $0xdeadbeefdeadbeef,%r8
	QUAD $0xbeefdeadbeefb849; WORD $0xdead
	// mov    %esi,%r9d
	WORD $0x8941; BYTE $0xf1
	// and    $0xffffffe0,%r9d
	LONG $0xe0e18341
	// je     1a9 <_ZN3pbf4HashEPKhj+0x1a9>
	LONG $0x0192840f; WORD $0x0000
	// add    %rdi,%r9
	WORD $0x0149; BYTE $0xf9
	// xor    %r10d,%r10d
	WORD $0x3145; BYTE $0xd2
	// mov    %r8,%rax
	WORD $0x894c; BYTE $0xc0
	// mov    %r8,%rdx
	WORD $0x894c; BYTE $0xc2
	// xor    %ecx,%ecx
	WORD $0xc931
	// data16 cs nopw 0x0(%rax,%rax,1)
	QUAD $0x0000841f0f2e6666; WORD $0x0000; BYTE $0x00
	// add    (%rdi),%rdx
	WORD $0x0348; BYTE $0x17
	// add    0x8(%rdi),%rax
	LONG $0x08470348
	// rorx   $0xe,%rdx,%rdx
	LONG $0xf0fbe3c4; WORD $0x0ed2
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// xor    %rdx,%rcx
	WORD $0x3148; BYTE $0xd1
	// rorx   $0xc,%rax,%rax
	LONG $0xf0fbe3c4; WORD $0x0cc0
	// add    %rcx,%rax
	WORD $0x0148; BYTE $0xc8
	// xor    %rax,%r10
	WORD $0x3149; BYTE $0xc2
	// rorx   $0x22,%rcx,%rcx
	LONG $0xf0fbe3c4; WORD $0x22c9
	// add    %r10,%rcx
	WORD $0x014c; BYTE $0xd1
	// xor    %rcx,%rdx
	WORD $0x3148; BYTE $0xca
	// rorx   $0x17,%r10,%r10
	LONG $0xf0fb43c4; WORD $0x17d2
	// add    %rdx,%r10
	WORD $0x0149; BYTE $0xd2
	// xor    %r10,%rax
	WORD $0x314c; BYTE $0xd0
	// rorx   $0xa,%rdx,%rdx
	LONG $0xf0fbe3c4; WORD $0x0ad2
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// xor    %rdx,%rcx
	WORD $0x3148; BYTE $0xd1
	// rorx   $0x10,%rax,%rax
	LONG $0xf0fbe3c4; WORD $0x10c0
	// add    %rcx,%rax
	WORD $0x0148; BYTE $0xc8
	// xor    %rax,%r10
	WORD $0x3149; BYTE $0xc2
	// rorx   $0x1a,%rcx,%rcx
	LONG $0xf0fbe3c4; WORD $0x1ac9
	// add    %r10,%rcx
	WORD $0x014c; BYTE $0xd1
	// xor    %rcx,%rdx
	WORD $0x3148; BYTE $0xca
	// rorx   $0x1b,%r10,%r10
	LONG $0xf0fb43c4; WORD $0x1bd2
	// add    %rdx,%r10
	WORD $0x0149; BYTE $0xd2
	// xor    %r10,%rax
	WORD $0x314c; BYTE $0xd0
	// rorx   $0x2,%rdx,%rdx
	LONG $0xf0fbe3c4; WORD $0x02d2
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// xor    %rdx,%rcx
	WORD $0x3148; BYTE $0xd1
	// rorx   $0x1e,%rax,%rax
	LONG $0xf0fbe3c4; WORD $0x1ec0
	// add    %rcx,%rax
	WORD $0x0148; BYTE $0xc8
	// xor    %rax,%r10
	WORD $0x3149; BYTE $0xc2
	// rorx   $0x3b,%rcx,%rcx
	LONG $0xf0fbe3c4; WORD $0x3bc9
	// add    %r10,%rcx
	WORD $0x014c; BYTE $0xd1
	// xor    %rcx,%rdx
	WORD $0x3148; BYTE $0xca
	// rorx   $0x1c,%r10,%r10
	LONG $0xf0fb43c4; WORD $0x1cd2
	// add    %rdx,%r10
	WORD $0x0149; BYTE $0xd2
	// xor    %r10,%rax
	WORD $0x314c; BYTE $0xd0
	// add    0x10(%rdi),%rcx
	LONG $0x104f0348
	// add    0x18(%rdi),%r10
	LONG $0x1857034c
	// add    $0x20,%rdi
	LONG $0x20c78348
	// cmp    %r9,%rdi
	WORD $0x394c; BYTE $0xcf
	// jb     30 <_ZN3pbf4HashEPKhj+0x30>
	LONG $0xff54820f; WORD $0xffff
	// test   $0x10,%sil
	LONG $0x10c6f640
	// je     181 <_ZN3pbf4HashEPKhj+0x181>
	LONG $0x009b840f; WORD $0x0000
	// add    (%rdi),%rdx
	WORD $0x0348; BYTE $0x17
	// add    0x8(%rdi),%rax
	LONG $0x08470348
	// rorx   $0xe,%rdx,%rdx
	LONG $0xf0fbe3c4; WORD $0x0ed2
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// xor    %rdx,%rcx
	WORD $0x3148; BYTE $0xd1
	// rorx   $0xc,%rax,%rax
	LONG $0xf0fbe3c4; WORD $0x0cc0
	// add    %rcx,%rax
	WORD $0x0148; BYTE $0xc8
	// xor    %rax,%r10
	WORD $0x3149; BYTE $0xc2
	// rorx   $0x22,%rcx,%rcx
	LONG $0xf0fbe3c4; WORD $0x22c9
	// add    %r10,%rcx
	WORD $0x014c; BYTE $0xd1
	// xor    %rcx,%rdx
	WORD $0x3148; BYTE $0xca
	// rorx   $0x17,%r10,%r9
	LONG $0xf0fb43c4; WORD $0x17ca
	// add    %rdx,%r9
	WORD $0x0149; BYTE $0xd1
	// xor    %r9,%rax
	WORD $0x314c; BYTE $0xc8
	// rorx   $0xa,%rdx,%rdx
	LONG $0xf0fbe3c4; WORD $0x0ad2
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// xor    %rdx,%rcx
	WORD $0x3148; BYTE $0xd1
	// rorx   $0x10,%rax,%rax
	LONG $0xf0fbe3c4; WORD $0x10c0
	// add    %rcx,%rax
	WORD $0x0148; BYTE $0xc8
	// xor    %rax,%r9
	WORD $0x3149; BYTE $0xc1
	// rorx   $0x1a,%rcx,%rcx
	LONG $0xf0fbe3c4; WORD $0x1ac9
	// add    %r9,%rcx
	WORD $0x014c; BYTE $0xc9
	// xor    %rcx,%rdx
	WORD $0x3148; BYTE $0xca
	// rorx   $0x1b,%r9,%r9
	LONG $0xf0fb43c4; WORD $0x1bc9
	// add    %rdx,%r9
	WORD $0x0149; BYTE $0xd1
	// xor    %r9,%rax
	WORD $0x314c; BYTE $0xc8
	// rorx   $0x2,%rdx,%rdx
	LONG $0xf0fbe3c4; WORD $0x02d2
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// xor    %rdx,%rcx
	WORD $0x3148; BYTE $0xd1
	// rorx   $0x1e,%rax,%rax
	LONG $0xf0fbe3c4; WORD $0x1ec0
	// add    %rcx,%rax
	WORD $0x0148; BYTE $0xc8
	// xor    %rax,%r9
	WORD $0x3149; BYTE $0xc1
	// rorx   $0x3b,%rcx,%rcx
	LONG $0xf0fbe3c4; WORD $0x3bc9
	// add    %r9,%rcx
	WORD $0x014c; BYTE $0xc9
	// xor    %rcx,%rdx
	WORD $0x3148; BYTE $0xca
	// rorx   $0x1c,%r9,%r10
	LONG $0xf0fb43c4; WORD $0x1cd1
	// add    %rdx,%r10
	WORD $0x0149; BYTE $0xd2
	// xor    %r10,%rax
	WORD $0x314c; BYTE $0xd0
	// add    $0x10,%rdi
	LONG $0x10c78348
	// mov    %rsi,%r9
	WORD $0x8949; BYTE $0xf1
	// shl    $0x38,%r9
	LONG $0x38e1c149
	// add    %rax,%r9
	WORD $0x0149; BYTE $0xc1
	// and    $0xf,%esi
	WORD $0xe683; BYTE $0x0f
	// lea    0x13f(%rip),%rax        # 2d4 <_ZN3pbf4HashEPKhj+0x2d4>
	LONG $0x3f058d48; WORD $0x0001; BYTE $0x00
	// movslq (%rax,%rsi,4),%rsi
	LONG $0xb0346348
	// add    %rax,%rsi
	WORD $0x0148; BYTE $0xc6
	// jmp    *%rsi
	WORD $0xe6ff
	// add    %r8,%rdx
	WORD $0x014c; BYTE $0xc2
	// add    %r8,%r9
	WORD $0x014d; BYTE $0xc1
	// jmp    24c <_ZN3pbf4HashEPKhj+0x24c>
	LONG $0x0000a3e9; BYTE $0x00
	// xor    %ecx,%ecx
	WORD $0xc931
	// xor    %r10d,%r10d
	WORD $0x3145; BYTE $0xd2
	// mov    %r8,%rdx
	WORD $0x894c; BYTE $0xc2
	// mov    %r8,%rax
	WORD $0x894c; BYTE $0xc0
	// test   $0x10,%sil
	LONG $0x10c6f640
	// jne    e6 <_ZN3pbf4HashEPKhj+0xe6>
	LONG $0xff28850f; WORD $0xffff
	// jmp    181 <_ZN3pbf4HashEPKhj+0x181>
	WORD $0xc1eb
	// movzbl 0x2(%rdi),%eax
	LONG $0x0247b60f
	// shl    $0x10,%rax
	LONG $0x10e0c148
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// movzbl 0x1(%rdi),%eax
	LONG $0x0147b60f
	// shl    $0x8,%rax
	LONG $0x08e0c148
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// movzbl (%rdi),%eax
	WORD $0xb60f; BYTE $0x07
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// jmp    24c <_ZN3pbf4HashEPKhj+0x24c>
	WORD $0x6eeb
	// movzbl 0x6(%rdi),%eax
	LONG $0x0647b60f
	// shl    $0x30,%rax
	LONG $0x30e0c148
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// movzbl 0x5(%rdi),%eax
	LONG $0x0547b60f
	// shl    $0x28,%rax
	LONG $0x28e0c148
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// movzbl 0x4(%rdi),%eax
	LONG $0x0447b60f
	// shl    $0x20,%rax
	LONG $0x20e0c148
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// mov    (%rdi),%eax
	WORD $0x078b
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// jmp    24c <_ZN3pbf4HashEPKhj+0x24c>
	WORD $0x46eb
	// movzbl 0xa(%rdi),%eax
	LONG $0x0a47b60f
	// shl    $0x10,%rax
	LONG $0x10e0c148
	// add    %rax,%r9
	WORD $0x0149; BYTE $0xc1
	// movzbl 0x9(%rdi),%eax
	LONG $0x0947b60f
	// shl    $0x8,%rax
	LONG $0x08e0c148
	// add    %rax,%r9
	WORD $0x0149; BYTE $0xc1
	// movzbl 0x8(%rdi),%eax
	LONG $0x0847b60f
	// jmp    246 <_ZN3pbf4HashEPKhj+0x246>
	WORD $0x24eb
	// movzbl 0xe(%rdi),%eax
	LONG $0x0e47b60f
	// shl    $0x30,%rax
	LONG $0x30e0c148
	// add    %rax,%r9
	WORD $0x0149; BYTE $0xc1
	// movzbl 0xd(%rdi),%eax
	LONG $0x0d47b60f
	// shl    $0x28,%rax
	LONG $0x28e0c148
	// add    %rax,%r9
	WORD $0x0149; BYTE $0xc1
	// movzbl 0xc(%rdi),%eax
	LONG $0x0c47b60f
	// shl    $0x20,%rax
	LONG $0x20e0c148
	// add    %rax,%r9
	WORD $0x0149; BYTE $0xc1
	// mov    0x8(%rdi),%eax
	WORD $0x478b; BYTE $0x08
	// add    %rax,%r9
	WORD $0x0149; BYTE $0xc1
	// add    (%rdi),%rdx
	WORD $0x0348; BYTE $0x17
	// xor    %rdx,%r9
	WORD $0x3149; BYTE $0xd1
	// rorx   $0x31,%rdx,%rax
	LONG $0xf0fbe3c4; WORD $0x31c2
	// add    %rax,%r9
	WORD $0x0149; BYTE $0xc1
	// xor    %r9,%rcx
	WORD $0x314c; BYTE $0xc9
	// rorx   $0xc,%r9,%rdx
	LONG $0xf0fbc3c4; WORD $0x0cd1
	// add    %rdx,%rcx
	WORD $0x0148; BYTE $0xd1
	// xor    %rcx,%r10
	WORD $0x3149; BYTE $0xca
	// rorx   $0x26,%rcx,%rcx
	LONG $0xf0fbe3c4; WORD $0x26c9
	// add    %rcx,%r10
	WORD $0x0149; BYTE $0xca
	// xor    %r10,%rax
	WORD $0x314c; BYTE $0xd0
	// rorx   $0xd,%r10,%rsi
	LONG $0xf0fbc3c4; WORD $0x0df2
	// add    %rsi,%rax
	WORD $0x0148; BYTE $0xf0
	// xor    %rax,%rdx
	WORD $0x3148; BYTE $0xc2
	// rorx   $0x24,%rax,%rax
	LONG $0xf0fbe3c4; WORD $0x24c0
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// xor    %rdx,%rcx
	WORD $0x3148; BYTE $0xd1
	// rorx   $0x37,%rdx,%rdi
	LONG $0xf0fbe3c4; WORD $0x37fa
	// add    %rdi,%rcx
	WORD $0x0148; BYTE $0xf9
	// xor    %rcx,%rsi
	WORD $0x3148; BYTE $0xce
	// rorx   $0x11,%rcx,%rcx
	LONG $0xf0fbe3c4; WORD $0x11c9
	// add    %rcx,%rsi
	WORD $0x0148; BYTE $0xce
	// xor    %rsi,%rax
	WORD $0x3148; BYTE $0xf0
	// rorx   $0xa,%rsi,%rdx
	LONG $0xf0fbe3c4; WORD $0x0ad6
	// add    %rdx,%rax
	WORD $0x0148; BYTE $0xd0
	// xor    %rax,%rdi
	WORD $0x3148; BYTE $0xc7
	// rorx   $0x20,%rax,%rax
	LONG $0xf0fbe3c4; WORD $0x20c0
	// add    %rdi,%rax
	WORD $0x0148; BYTE $0xf8
	// xor    %rax,%rcx
	WORD $0x3148; BYTE $0xc1
	// rorx   $0x27,%rax,%rax
	LONG $0xf0fbe3c4; WORD $0x27c0
	// add    %rcx,%rax
	WORD $0x0148; BYTE $0xc8
	// xor    %rax,%rdx
	WORD $0x3148; BYTE $0xc2
	// rorx   $0x1,%rax,%rax
	LONG $0xf0fbe3c4; WORD $0x01c0
	// add    %rax,%rdx
	WORD $0x0148; BYTE $0xc2
	// ret    
	BYTE $0xc3
	// data 67
	QUAD $0x02fffffeca001f0f; QUAD $0xecfffffef7ffffff; QUAD $0x20ffffff2bfffffe; QUAD $0x0affffff15ffffff; QUAD $0x48ffffff75ffffff; QUAD $0x32ffffff3dffffff; QUAD $0x64ffffff6fffffff; QUAD $0x4effffff59ffffff; WORD $0xffff; BYTE $0xff

TEXT PBF4_Set(SB), NOSPLIT, $0
	// push   %rbp
	BYTE $0x55
	// push   %r15
	WORD $0x5741
	// push   %r14
	WORD $0x5641
	// push   %rbx
	BYTE $0x53
	// push   %rax
	BYTE $0x50
	// mov    %edx,%r15d
	WORD $0x8941; BYTE $0xd7
	// mov    %esi,%ebx
	WORD $0xf389
	// mov    %rdi,%r14
	WORD $0x8949; BYTE $0xfe
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// mov    %r8d,%esi
	WORD $0x8944; BYTE $0xc6
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	WORD $0x8948; BYTE $0xc1
	// mov    %rax,%rsi
	WORD $0x8948; BYTE $0xc6
	// shr    $0x20,%rsi
	LONG $0x20eec148
	// rorx   $0x2,%edx,%eax
	LONG $0xf07be3c4; WORD $0x02c2
	// shr    $0x20,%rdx
	LONG $0x20eac148
	// rorx   $0x6,%ecx,%edi
	LONG $0xf07be3c4; WORD $0x06f9
	// rorx   $0x4,%esi,%ebp
	LONG $0xf07be3c4; WORD $0x04ee
	// xor    %edi,%eax
	WORD $0xf831
	// xor    %edx,%eax
	WORD $0xd031
	// xor    %ebp,%eax
	WORD $0xe831
	// xor    %edx,%edx
	WORD $0xd231
	// div    %r15d
	WORD $0xf741; BYTE $0xf7
	// shlx   %rbx,%rdx,%rax
	LONG $0xf7e1e2c4; BYTE $0xc2
	// add    %r14,%rax
	WORD $0x014c; BYTE $0xf0
	// mov    %rcx,%r8
	WORD $0x8949; BYTE $0xc8
	// add    $0x3,%bl
	WORD $0xc380; BYTE $0x03
	// bzhi   %ebx,%ecx,%edi
	LONG $0xf560e2c4; BYTE $0xf9
	// shr    $0x10,%rcx
	LONG $0x10e9c148
	// shr    $0x30,%r8
	LONG $0x30e8c149
	// movzwl %di,%ebp
	WORD $0xb70f; BYTE $0xef
	// and    $0x7,%dil
	LONG $0x07e78040
	// shr    $0x3,%rbp
	LONG $0x03edc148
	// movzbl 0x0(%rbp,%rax,1),%edx
	LONG $0x0554b60f; BYTE $0x00
	// shrx   %edi,%edx,%r9d
	LONG $0xf74362c4; BYTE $0xca
	// bts    %edi,%edx
	WORD $0xab0f; BYTE $0xfa
	// mov    %dl,0x0(%rbp,%rax,1)
	LONG $0x00055488
	// bzhi   %ebx,%ecx,%ecx
	LONG $0xf560e2c4; BYTE $0xc9
	// movzwl %cx,%edx
	WORD $0xb70f; BYTE $0xd1
	// mov    %ecx,%edi
	WORD $0xcf89
	// and    $0x7,%dil
	LONG $0x07e78040
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%ebp
	LONG $0x022cb60f
	// shrx   %edi,%ebp,%ecx
	LONG $0xf743e2c4; BYTE $0xcd
	// and    %r9d,%ecx
	WORD $0x2144; BYTE $0xc9
	// bts    %edi,%ebp
	WORD $0xab0f; BYTE $0xfd
	// mov    %bpl,(%rdx,%rax,1)
	LONG $0x022c8840
	// bzhi   %ebx,%esi,%edx
	LONG $0xf560e2c4; BYTE $0xd6
	// movzwl %dx,%esi
	WORD $0xb70f; BYTE $0xf2
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%edi
	LONG $0x063cb60f
	// shrx   %edx,%edi,%ebp
	LONG $0xf76be2c4; BYTE $0xef
	// bts    %edx,%edi
	WORD $0xab0f; BYTE $0xd7
	// mov    %dil,(%rsi,%rax,1)
	LONG $0x063c8840
	// bzhi   %ebx,%r8d,%edx
	LONG $0xf560c2c4; BYTE $0xd0
	// mov    %edx,%esi
	WORD $0xd689
	// and    $0x7,%sil
	LONG $0x07e68040
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%edi
	LONG $0x023cb60f
	// shrx   %esi,%edi,%ebx
	LONG $0xf74be2c4; BYTE $0xdf
	// and    %ebp,%ebx
	WORD $0xeb21
	// and    %ecx,%ebx
	WORD $0xcb21
	// bts    %esi,%edi
	WORD $0xab0f; BYTE $0xf7
	// mov    %dil,(%rdx,%rax,1)
	LONG $0x023c8840
	// test   $0x1,%bl
	WORD $0xc3f6; BYTE $0x01
	// sete   %al
	WORD $0x940f; BYTE $0xc0
	// add    $0x8,%rsp
	LONG $0x08c48348
	// pop    %rbx
	BYTE $0x5b
	// pop    %r14
	WORD $0x5e41
	// pop    %r15
	WORD $0x5f41
	// pop    %rbp
	BYTE $0x5d
	// ret    
	BYTE $0xc3

TEXT PBF4_Test(SB), NOSPLIT, $0
	// push   %rbp
	BYTE $0x55
	// push   %r15
	WORD $0x5741
	// push   %r14
	WORD $0x5641
	// push   %rbx
	BYTE $0x53
	// push   %rax
	BYTE $0x50
	// mov    %edx,%r15d
	WORD $0x8941; BYTE $0xd7
	// mov    %esi,%ebx
	WORD $0xf389
	// mov    %rdi,%r14
	WORD $0x8949; BYTE $0xfe
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// mov    %r8d,%esi
	WORD $0x8944; BYTE $0xc6
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	WORD $0x8948; BYTE $0xc1
	// mov    %rax,%rsi
	WORD $0x8948; BYTE $0xc6
	// shr    $0x20,%rsi
	LONG $0x20eec148
	// rorx   $0x2,%edx,%eax
	LONG $0xf07be3c4; WORD $0x02c2
	// shr    $0x20,%rdx
	LONG $0x20eac148
	// rorx   $0x6,%ecx,%edi
	LONG $0xf07be3c4; WORD $0x06f9
	// rorx   $0x4,%esi,%ebp
	LONG $0xf07be3c4; WORD $0x04ee
	// xor    %edi,%eax
	WORD $0xf831
	// xor    %edx,%eax
	WORD $0xd031
	// xor    %ebp,%eax
	WORD $0xe831
	// xor    %edx,%edx
	WORD $0xd231
	// div    %r15d
	WORD $0xf741; BYTE $0xf7
	// xor    %eax,%eax
	WORD $0xc031
	// shlx   %rbx,%rdx,%rdx
	LONG $0xf7e1e2c4; BYTE $0xd2
	// add    %r14,%rdx
	WORD $0x014c; BYTE $0xf2
	// add    $0x3,%bl
	WORD $0xc380; BYTE $0x03
	// bzhi   %ebx,%ecx,%edi
	LONG $0xf560e2c4; BYTE $0xf9
	// movzwl %di,%ebp
	WORD $0xb70f; BYTE $0xef
	// and    $0x7,%dil
	LONG $0x07e78040
	// mov    $0x1,%r8d
	LONG $0x0001b841; WORD $0x0000
	// shlx   %edi,%r8d,%edi
	LONG $0xf741c2c4; BYTE $0xf8
	// shr    $0x3,%rbp
	LONG $0x03edc148
	// movzbl 0x0(%rbp,%rdx,1),%ebp
	LONG $0x156cb60f; BYTE $0x00
	// test   %ebp,%edi
	WORD $0xef85
	// je     509 <PBF4_Test+0xe9>
	WORD $0x7374
	// mov    $0xffffffff,%eax
	LONG $0xffffffb8; BYTE $0xff
	// shlx   %ebx,%eax,%eax
	LONG $0xf761e2c4; BYTE $0xc0
	// not    %eax
	WORD $0xd0f7
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// shr    $0x10,%rdi
	LONG $0x10efc148
	// mov    %eax,%ebp
	WORD $0xc589
	// and    %edi,%ebp
	WORD $0xfd21
	// movzwl %bp,%edi
	WORD $0xb70f; BYTE $0xfd
	// and    $0x7,%bpl
	LONG $0x07e58040
	// shlx   %ebp,%r8d,%ebp
	LONG $0xf751c2c4; BYTE $0xe8
	// shr    $0x3,%rdi
	LONG $0x03efc148
	// movzbl (%rdx,%rdi,1),%edi
	LONG $0x3a3cb60f
	// test   %ebp,%edi
	WORD $0xef85
	// je     507 <PBF4_Test+0xe7>
	WORD $0x4274
	// and    %eax,%esi
	WORD $0xc621
	// mov    %esi,%ebp
	WORD $0xf589
	// and    $0x7,%bpl
	LONG $0x07e58040
	// mov    $0x1,%edi
	LONG $0x000001bf; BYTE $0x00
	// shlx   %ebp,%edi,%ebp
	LONG $0xf751e2c4; BYTE $0xef
	// movzwl %si,%esi
	WORD $0xb70f; BYTE $0xf6
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rdx,%rsi,1),%esi
	LONG $0x3234b60f
	// test   %ebp,%esi
	WORD $0xee85
	// je     507 <PBF4_Test+0xe7>
	WORD $0x2174
	// shr    $0x30,%rcx
	LONG $0x30e9c148
	// and    %eax,%ecx
	WORD $0xc121
	// mov    %ecx,%eax
	WORD $0xc889
	// and    $0x7,%al
	WORD $0x0724
	// shlx   %eax,%edi,%eax
	LONG $0xf779e2c4; BYTE $0xc7
	// movzwl %cx,%ecx
	WORD $0xb70f; BYTE $0xc9
	// shr    $0x3,%rcx
	LONG $0x03e9c148
	// movzbl (%rdx,%rcx,1),%ecx
	LONG $0x0a0cb60f
	// test   %eax,%ecx
	WORD $0xc185
	// setne  %al
	WORD $0x950f; BYTE $0xc0
	// jmp    509 <PBF4_Test+0xe9>
	WORD $0x02eb
	// xor    %eax,%eax
	WORD $0xc031
	// add    $0x8,%rsp
	LONG $0x08c48348
	// pop    %rbx
	BYTE $0x5b
	// pop    %r14
	WORD $0x5e41
	// pop    %r15
	WORD $0x5f41
	// pop    %rbp
	BYTE $0x5d
	// ret    
	BYTE $0xc3

TEXT PBF5_Set(SB), NOSPLIT, $0
	// push   %rbp
	BYTE $0x55
	// push   %r15
	WORD $0x5741
	// push   %r14
	WORD $0x5641
	// push   %rbx
	BYTE $0x53
	// push   %rax
	BYTE $0x50
	// mov    %edx,%r15d
	WORD $0x8941; BYTE $0xd7
	// mov    %esi,%ebx
	WORD $0xf389
	// mov    %rdi,%r14
	WORD $0x8949; BYTE $0xfe
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// mov    %r8d,%esi
	WORD $0x8944; BYTE $0xc6
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rsi
	WORD $0x8948; BYTE $0xc6
	// mov    %rdx,%r8
	WORD $0x8949; BYTE $0xd0
	// mov    %rsi,%rdi
	WORD $0x8948; BYTE $0xf7
	// shr    $0x20,%rdi
	LONG $0x20efc148
	// shr    $0x20,%rdx
	LONG $0x20eac148
	// rorx   $0x6,%esi,%ecx
	LONG $0xf07be3c4; WORD $0x06ce
	// rorx   $0x4,%edi,%ebp
	LONG $0xf07be3c4; WORD $0x04ef
	// rorx   $0x2,%r8d,%eax
	LONG $0xf07bc3c4; WORD $0x02c0
	// xor    %ecx,%eax
	WORD $0xc831
	// xor    %edx,%eax
	WORD $0xd031
	// xor    %ebp,%eax
	WORD $0xe831
	// xor    %edx,%edx
	WORD $0xd231
	// div    %r15d
	WORD $0xf741; BYTE $0xf7
	// shlx   %rbx,%rdx,%rax
	LONG $0xf7e1e2c4; BYTE $0xc2
	// add    %r14,%rax
	WORD $0x014c; BYTE $0xf0
	// mov    %rsi,%r9
	WORD $0x8949; BYTE $0xf1
	// add    $0x3,%bl
	WORD $0xc380; BYTE $0x03
	// bzhi   %ebx,%esi,%ecx
	LONG $0xf560e2c4; BYTE $0xce
	// shr    $0x10,%rsi
	LONG $0x10eec148
	// shr    $0x30,%r9
	LONG $0x30e9c149
	// movzwl %cx,%ebp
	WORD $0xb70f; BYTE $0xe9
	// and    $0x7,%cl
	WORD $0xe180; BYTE $0x07
	// shr    $0x3,%rbp
	LONG $0x03edc148
	// movzbl 0x0(%rbp,%rax,1),%edx
	LONG $0x0554b60f; BYTE $0x00
	// shrx   %ecx,%edx,%r10d
	LONG $0xf77362c4; BYTE $0xd2
	// bts    %ecx,%edx
	WORD $0xab0f; BYTE $0xca
	// mov    %dl,0x0(%rbp,%rax,1)
	LONG $0x00055488
	// bzhi   %ebx,%esi,%ecx
	LONG $0xf560e2c4; BYTE $0xce
	// movzwl %cx,%edx
	WORD $0xb70f; BYTE $0xd1
	// and    $0x7,%cl
	WORD $0xe180; BYTE $0x07
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%ebp
	LONG $0x022cb60f
	// shrx   %ecx,%ebp,%esi
	LONG $0xf773e2c4; BYTE $0xf5
	// and    %r10d,%esi
	WORD $0x2144; BYTE $0xd6
	// bts    %ecx,%ebp
	WORD $0xab0f; BYTE $0xcd
	// mov    %bpl,(%rdx,%rax,1)
	LONG $0x022c8840
	// bzhi   %ebx,%edi,%ecx
	LONG $0xf560e2c4; BYTE $0xcf
	// movzwl %cx,%edx
	WORD $0xb70f; BYTE $0xd1
	// and    $0x7,%cl
	WORD $0xe180; BYTE $0x07
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%edi
	LONG $0x023cb60f
	// shrx   %ecx,%edi,%r10d
	LONG $0xf77362c4; BYTE $0xd7
	// bts    %ecx,%edi
	WORD $0xab0f; BYTE $0xcf
	// mov    %dil,(%rdx,%rax,1)
	LONG $0x023c8840
	// bzhi   %ebx,%r9d,%ecx
	LONG $0xf560c2c4; BYTE $0xc9
	// mov    %ecx,%edx
	WORD $0xca89
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rcx
	LONG $0x03e9c148
	// movzbl (%rcx,%rax,1),%edi
	LONG $0x013cb60f
	// shrx   %edx,%edi,%ebp
	LONG $0xf76be2c4; BYTE $0xef
	// and    %r10d,%ebp
	WORD $0x2144; BYTE $0xd5
	// and    %esi,%ebp
	WORD $0xf521
	// bts    %edx,%edi
	WORD $0xab0f; BYTE $0xd7
	// mov    %dil,(%rcx,%rax,1)
	LONG $0x013c8840
	// bzhi   %ebx,%r8d,%ecx
	LONG $0xf560c2c4; BYTE $0xc8
	// movzwl %cx,%edx
	WORD $0xb70f; BYTE $0xd1
	// and    $0x7,%cl
	WORD $0xe180; BYTE $0x07
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%esi
	LONG $0x0234b60f
	// shrx   %ecx,%esi,%edi
	LONG $0xf773e2c4; BYTE $0xfe
	// and    %ebp,%edi
	WORD $0xef21
	// bts    %ecx,%esi
	WORD $0xab0f; BYTE $0xce
	// mov    %sil,(%rdx,%rax,1)
	LONG $0x02348840
	// test   $0x1,%dil
	LONG $0x01c7f640
	// sete   %al
	WORD $0x940f; BYTE $0xc0
	// add    $0x8,%rsp
	LONG $0x08c48348
	// pop    %rbx
	BYTE $0x5b
	// pop    %r14
	WORD $0x5e41
	// pop    %r15
	WORD $0x5f41
	// pop    %rbp
	BYTE $0x5d
	// ret    
	BYTE $0xc3

TEXT PBF5_Test(SB), NOSPLIT, $0
	// push   %rbp
	BYTE $0x55
	// push   %r15
	WORD $0x5741
	// push   %r14
	WORD $0x5641
	// push   %rbx
	BYTE $0x53
	// push   %rax
	BYTE $0x50
	// mov    %edx,%r15d
	WORD $0x8941; BYTE $0xd7
	// mov    %esi,%ebx
	WORD $0xf389
	// mov    %rdi,%r14
	WORD $0x8949; BYTE $0xfe
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// mov    %r8d,%esi
	WORD $0x8944; BYTE $0xc6
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	WORD $0x8948; BYTE $0xc1
	// mov    %rdx,%rbp
	WORD $0x8948; BYTE $0xd5
	// rorx   $0x6,%ecx,%edx
	LONG $0xf07be3c4; WORD $0x06d1
	// mov    %rax,%rdi
	WORD $0x8948; BYTE $0xc7
	// shr    $0x20,%rdi
	LONG $0x20efc148
	// rorx   $0x2,%ebp,%eax
	LONG $0xf07be3c4; WORD $0x02c5
	// mov    %rbp,%rsi
	WORD $0x8948; BYTE $0xee
	// shr    $0x20,%rsi
	LONG $0x20eec148
	// rorx   $0x4,%edi,%edi
	LONG $0xf07be3c4; WORD $0x04ff
	// xor    %edx,%eax
	WORD $0xd031
	// xor    %esi,%eax
	WORD $0xf031
	// xor    %edi,%eax
	WORD $0xf831
	// xor    %edx,%edx
	WORD $0xd231
	// div    %r15d
	WORD $0xf741; BYTE $0xf7
	// vmovq  %rbp,%xmm0
	LONG $0x6ef9e1c4; BYTE $0xc5
	// vmovq  %rcx,%xmm1
	LONG $0x6ef9e1c4; BYTE $0xc9
	// shlx   %rbx,%rdx,%rax
	LONG $0xf7e1e2c4; BYTE $0xc2
	// add    %r14,%rax
	WORD $0x014c; BYTE $0xf0
	// vpunpcklqdq %xmm0,%xmm1,%xmm0
	LONG $0xc06cf1c5
	// add    $0x3,%bl
	WORD $0xc380; BYTE $0x03
	// mov    $0xffffffff,%ecx
	LONG $0xffffffb9; BYTE $0xff
	// shlx   %ebx,%ecx,%ecx
	LONG $0xf761e2c4; BYTE $0xc9
	// not    %ecx
	WORD $0xd1f7
	// vmovd  %ecx,%xmm1
	LONG $0xc96ef9c5
	// vpbroadcastd %xmm1,%ymm1
	LONG $0x587de2c4; BYTE $0xc9
	// vpsrld $0x10,%xmm0,%xmm2
	LONG $0xd072e9c5; BYTE $0x10
	// vinserti128 $0x1,%xmm2,%ymm0,%ymm0
	LONG $0x387de3c4; WORD $0x01c2
	// vpand  %ymm0,%ymm1,%ymm0
	LONG $0xc0dbf5c5
	// vpsrld $0x5,%ymm0,%ymm1
	LONG $0xd072f5c5; BYTE $0x05
	// vmovdqa 0x4b(%rip),%ymm2        # 720 <PBF5_Test+0xe0>
	QUAD $0x0000004b156ffdc5
	// vpcmpeqd %ymm3,%ymm3,%ymm3
	LONG $0xdb76e5c5
	// vpgatherdd %ymm2,(%rax,%ymm1,4),%ymm3
	LONG $0x906de2c4; WORD $0x881c
	// vpbroadcastd 0x58(%rip),%ymm1        # 740 <PBF5_Test+0x100>
	QUAD $0x0000580d587de2c4; BYTE $0x00
	// vpand  %ymm1,%ymm0,%ymm0
	LONG $0xc1dbfdc5
	// vpbroadcastd 0x4f(%rip),%ymm1        # 744 <PBF5_Test+0x104>
	QUAD $0x00004f0d587de2c4; BYTE $0x00
	// vpsllvd %ymm0,%ymm1,%ymm0
	LONG $0x4775e2c4; BYTE $0xc0
	// vpandn %ymm0,%ymm3,%ymm1
	LONG $0xc8dfe5c5
	// vptest %ymm0,%ymm1
	LONG $0x177de2c4; BYTE $0xc8
	// sete   %al
	WORD $0x940f; BYTE $0xc0
	// add    $0x8,%rsp
	LONG $0x08c48348
	// pop    %rbx
	BYTE $0x5b
	// pop    %r14
	WORD $0x5e41
	// pop    %r15
	WORD $0x5f41
	// pop    %rbp
	BYTE $0x5d
	// vzeroupper 
	WORD $0xf8c5; BYTE $0x77
	// ret    
	BYTE $0xc3
	// data 52
	QUAD $0x0000841f0f2e6666; QUAD $0xffffffff90000000; QUAD $0xffffffffffffffff; QUAD $0xffffffff00000000; QUAD $0x00000000ffffffff; QUAD $0x0000001f00000000; LONG $0x00000001

TEXT PBF6_Set(SB), NOSPLIT, $0
	// push   %rbp
	BYTE $0x55
	// push   %r15
	WORD $0x5741
	// push   %r14
	WORD $0x5641
	// push   %r12
	WORD $0x5441
	// push   %rbx
	BYTE $0x53
	// mov    %edx,%r15d
	WORD $0x8941; BYTE $0xd7
	// mov    %esi,%r12d
	WORD $0x8941; BYTE $0xf4
	// mov    %rdi,%r14
	WORD $0x8949; BYTE $0xfe
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// mov    %r8d,%esi
	WORD $0x8944; BYTE $0xc6
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rsi
	WORD $0x8948; BYTE $0xc6
	// mov    %rdx,%rcx
	WORD $0x8948; BYTE $0xd1
	// mov    %rax,%r8
	WORD $0x8949; BYTE $0xc0
	// shr    $0x20,%r8
	LONG $0x20e8c149
	// shr    $0x20,%rdx
	LONG $0x20eac148
	// rorx   $0x6,%esi,%edi
	LONG $0xf07be3c4; WORD $0x06fe
	// rorx   $0x4,%r8d,%ebp
	LONG $0xf07bc3c4; WORD $0x04e8
	// rorx   $0x2,%ecx,%eax
	LONG $0xf07be3c4; WORD $0x02c1
	// xor    %edi,%eax
	WORD $0xf831
	// xor    %edx,%eax
	WORD $0xd031
	// xor    %ebp,%eax
	WORD $0xe831
	// xor    %edx,%edx
	WORD $0xd231
	// div    %r15d
	WORD $0xf741; BYTE $0xf7
	// shlx   %r12,%rdx,%rax
	LONG $0xf799e2c4; BYTE $0xc2
	// add    %r14,%rax
	WORD $0x014c; BYTE $0xf0
	// mov    %rsi,%r10
	WORD $0x8949; BYTE $0xf2
	// add    $0x3,%r12b
	LONG $0x03c48041
	// bzhi   %r12d,%esi,%r9d
	LONG $0xf51862c4; BYTE $0xce
	// shr    $0x10,%rsi
	LONG $0x10eec148
	// shr    $0x30,%r10
	LONG $0x30eac149
	// bzhi   %r12d,%ecx,%r11d
	LONG $0xf51862c4; BYTE $0xd9
	// shr    $0x10,%rcx
	LONG $0x10e9c148
	// movzwl %r9w,%ebp
	LONG $0xe9b70f41
	// mov    %r9d,%edx
	WORD $0x8944; BYTE $0xca
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rbp
	LONG $0x03edc148
	// movzbl 0x0(%rbp,%rax,1),%ebx
	LONG $0x055cb60f; BYTE $0x00
	// shrx   %edx,%ebx,%edi
	LONG $0xf76be2c4; BYTE $0xfb
	// bts    %edx,%ebx
	WORD $0xab0f; BYTE $0xd3
	// mov    %bl,0x0(%rbp,%rax,1)
	LONG $0x00055c88
	// bzhi   %r12d,%esi,%edx
	LONG $0xf518e2c4; BYTE $0xd6
	// movzwl %dx,%esi
	WORD $0xb70f; BYTE $0xf2
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%ebp
	LONG $0x062cb60f
	// shrx   %edx,%ebp,%ebx
	LONG $0xf76be2c4; BYTE $0xdd
	// and    %edi,%ebx
	WORD $0xfb21
	// bts    %edx,%ebp
	WORD $0xab0f; BYTE $0xd5
	// mov    %bpl,(%rsi,%rax,1)
	LONG $0x062c8840
	// bzhi   %r12d,%r8d,%edx
	LONG $0xf518c2c4; BYTE $0xd0
	// movzwl %dx,%esi
	WORD $0xb70f; BYTE $0xf2
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%edi
	LONG $0x063cb60f
	// shrx   %edx,%edi,%r8d
	LONG $0xf76b62c4; BYTE $0xc7
	// bts    %edx,%edi
	WORD $0xab0f; BYTE $0xd7
	// mov    %dil,(%rsi,%rax,1)
	LONG $0x063c8840
	// bzhi   %r12d,%r10d,%edx
	LONG $0xf518c2c4; BYTE $0xd2
	// mov    %edx,%esi
	WORD $0xd689
	// and    $0x7,%sil
	LONG $0x07e68040
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%edi
	LONG $0x023cb60f
	// shrx   %esi,%edi,%ebp
	LONG $0xf74be2c4; BYTE $0xef
	// and    %r8d,%ebp
	WORD $0x2144; BYTE $0xc5
	// and    %ebx,%ebp
	WORD $0xdd21
	// bts    %esi,%edi
	WORD $0xab0f; BYTE $0xf7
	// mov    %dil,(%rdx,%rax,1)
	LONG $0x023c8840
	// movzwl %r11w,%edx
	LONG $0xd3b70f41
	// mov    %r11d,%esi
	WORD $0x8944; BYTE $0xde
	// and    $0x7,%sil
	LONG $0x07e68040
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%edi
	LONG $0x023cb60f
	// shrx   %esi,%edi,%ebx
	LONG $0xf74be2c4; BYTE $0xdf
	// bts    %esi,%edi
	WORD $0xab0f; BYTE $0xf7
	// mov    %dil,(%rdx,%rax,1)
	LONG $0x023c8840
	// bzhi   %r12d,%ecx,%ecx
	LONG $0xf518e2c4; BYTE $0xc9
	// movzwl %cx,%edx
	WORD $0xb70f; BYTE $0xd1
	// and    $0x7,%cl
	WORD $0xe180; BYTE $0x07
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%esi
	LONG $0x0234b60f
	// shrx   %ecx,%esi,%edi
	LONG $0xf773e2c4; BYTE $0xfe
	// and    %ebx,%edi
	WORD $0xdf21
	// and    %ebp,%edi
	WORD $0xef21
	// bts    %ecx,%esi
	WORD $0xab0f; BYTE $0xce
	// mov    %sil,(%rdx,%rax,1)
	LONG $0x02348840
	// test   $0x1,%dil
	LONG $0x01c7f640
	// sete   %al
	WORD $0x940f; BYTE $0xc0
	// pop    %rbx
	BYTE $0x5b
	// pop    %r12
	WORD $0x5c41
	// pop    %r14
	WORD $0x5e41
	// pop    %r15
	WORD $0x5f41
	// pop    %rbp
	BYTE $0x5d
	// ret    
	BYTE $0xc3

TEXT PBF6_Test(SB), NOSPLIT, $0
	// push   %rbp
	BYTE $0x55
	// push   %r15
	WORD $0x5741
	// push   %r14
	WORD $0x5641
	// push   %rbx
	BYTE $0x53
	// push   %rax
	BYTE $0x50
	// mov    %edx,%r15d
	WORD $0x8941; BYTE $0xd7
	// mov    %esi,%ebx
	WORD $0xf389
	// mov    %rdi,%r14
	WORD $0x8949; BYTE $0xfe
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// mov    %r8d,%esi
	WORD $0x8944; BYTE $0xc6
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	WORD $0x8948; BYTE $0xc1
	// mov    %rdx,%rbp
	WORD $0x8948; BYTE $0xd5
	// rorx   $0x6,%ecx,%edx
	LONG $0xf07be3c4; WORD $0x06d1
	// mov    %rax,%rdi
	WORD $0x8948; BYTE $0xc7
	// shr    $0x20,%rdi
	LONG $0x20efc148
	// rorx   $0x2,%ebp,%eax
	LONG $0xf07be3c4; WORD $0x02c5
	// mov    %rbp,%rsi
	WORD $0x8948; BYTE $0xee
	// shr    $0x20,%rsi
	LONG $0x20eec148
	// rorx   $0x4,%edi,%edi
	LONG $0xf07be3c4; WORD $0x04ff
	// xor    %edx,%eax
	WORD $0xd031
	// xor    %esi,%eax
	WORD $0xf031
	// xor    %edi,%eax
	WORD $0xf831
	// xor    %edx,%edx
	WORD $0xd231
	// div    %r15d
	WORD $0xf741; BYTE $0xf7
	// vmovq  %rbp,%xmm0
	LONG $0x6ef9e1c4; BYTE $0xc5
	// vmovq  %rcx,%xmm1
	LONG $0x6ef9e1c4; BYTE $0xc9
	// shlx   %rbx,%rdx,%rax
	LONG $0xf7e1e2c4; BYTE $0xc2
	// add    %r14,%rax
	WORD $0x014c; BYTE $0xf0
	// vpunpcklqdq %xmm0,%xmm1,%xmm0
	LONG $0xc06cf1c5
	// add    $0x3,%bl
	WORD $0xc380; BYTE $0x03
	// mov    $0xffffffff,%ecx
	LONG $0xffffffb9; BYTE $0xff
	// shlx   %ebx,%ecx,%ecx
	LONG $0xf761e2c4; BYTE $0xc9
	// not    %ecx
	WORD $0xd1f7
	// vmovd  %ecx,%xmm1
	LONG $0xc96ef9c5
	// vpbroadcastd %xmm1,%ymm1
	LONG $0x587de2c4; BYTE $0xc9
	// vpsrld $0x10,%xmm0,%xmm2
	LONG $0xd072e9c5; BYTE $0x10
	// vinserti128 $0x1,%xmm2,%ymm0,%ymm0
	LONG $0x387de3c4; WORD $0x01c2
	// vpand  %ymm0,%ymm1,%ymm0
	LONG $0xc0dbf5c5
	// vpsrld $0x5,%ymm0,%ymm1
	LONG $0xd072f5c5; BYTE $0x05
	// vmovdqa 0x4b(%rip),%ymm2        # 9a0 <PBF6_Test+0xe0>
	QUAD $0x0000004b156ffdc5
	// vpcmpeqd %ymm3,%ymm3,%ymm3
	LONG $0xdb76e5c5
	// vpgatherdd %ymm2,(%rax,%ymm1,4),%ymm3
	LONG $0x906de2c4; WORD $0x881c
	// vpbroadcastd 0x58(%rip),%ymm1        # 9c0 <PBF6_Test+0x100>
	QUAD $0x0000580d587de2c4; BYTE $0x00
	// vpand  %ymm1,%ymm0,%ymm0
	LONG $0xc1dbfdc5
	// vpbroadcastd 0x4f(%rip),%ymm1        # 9c4 <PBF6_Test+0x104>
	QUAD $0x00004f0d587de2c4; BYTE $0x00
	// vpsllvd %ymm0,%ymm1,%ymm0
	LONG $0x4775e2c4; BYTE $0xc0
	// vpandn %ymm0,%ymm3,%ymm1
	LONG $0xc8dfe5c5
	// vptest %ymm0,%ymm1
	LONG $0x177de2c4; BYTE $0xc8
	// sete   %al
	WORD $0x940f; BYTE $0xc0
	// add    $0x8,%rsp
	LONG $0x08c48348
	// pop    %rbx
	BYTE $0x5b
	// pop    %r14
	WORD $0x5e41
	// pop    %r15
	WORD $0x5f41
	// pop    %rbp
	BYTE $0x5d
	// vzeroupper 
	WORD $0xf8c5; BYTE $0x77
	// ret    
	BYTE $0xc3
	// data 52
	QUAD $0x0000841f0f2e6666; QUAD $0xffffffff90000000; QUAD $0xffffffffffffffff; QUAD $0xffffffff00000000; QUAD $0xffffffffffffffff; QUAD $0x0000001f00000000; LONG $0x00000001

TEXT PBF7_Set(SB), NOSPLIT, $0
	// push   %rbp
	BYTE $0x55
	// push   %r15
	WORD $0x5741
	// push   %r14
	WORD $0x5641
	// push   %rbx
	BYTE $0x53
	// push   %rax
	BYTE $0x50
	// mov    %edx,%ebp
	WORD $0xd589
	// mov    %esi,%r15d
	WORD $0x8941; BYTE $0xf7
	// mov    %rdi,%r14
	WORD $0x8949; BYTE $0xfe
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// mov    %r8d,%esi
	WORD $0x8944; BYTE $0xc6
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rsi
	WORD $0x8948; BYTE $0xc6
	// mov    %rdx,%rcx
	WORD $0x8948; BYTE $0xd1
	// mov    %rax,%r9
	WORD $0x8949; BYTE $0xc1
	// shr    $0x20,%r9
	LONG $0x20e9c149
	// mov    %rdx,%r8
	WORD $0x8949; BYTE $0xd0
	// shr    $0x20,%r8
	LONG $0x20e8c149
	// rorx   $0x6,%esi,%edx
	LONG $0xf07be3c4; WORD $0x06d6
	// rorx   $0x4,%r9d,%edi
	LONG $0xf07bc3c4; WORD $0x04f9
	// rorx   $0x2,%ecx,%eax
	LONG $0xf07be3c4; WORD $0x02c1
	// xor    %edx,%eax
	WORD $0xd031
	// xor    %r8d,%eax
	WORD $0x3144; BYTE $0xc0
	// xor    %edi,%eax
	WORD $0xf831
	// xor    %edx,%edx
	WORD $0xd231
	// div    %ebp
	WORD $0xf5f7
	// shlx   %r15,%rdx,%rax
	LONG $0xf781e2c4; BYTE $0xc2
	// add    %r14,%rax
	WORD $0x014c; BYTE $0xf0
	// mov    %rsi,%r11
	WORD $0x8949; BYTE $0xf3
	// add    $0x3,%r15b
	LONG $0x03c78041
	// bzhi   %r15d,%esi,%r10d
	LONG $0xf50062c4; BYTE $0xd6
	// shr    $0x10,%rsi
	LONG $0x10eec148
	// shr    $0x30,%r11
	LONG $0x30ebc149
	// bzhi   %r15d,%ecx,%r14d
	LONG $0xf50062c4; BYTE $0xf1
	// mov    %rcx,%rbp
	WORD $0x8948; BYTE $0xcd
	// shr    $0x10,%rbp
	LONG $0x10edc148
	// movzwl %r10w,%ecx
	LONG $0xcab70f41
	// mov    %r10d,%edx
	WORD $0x8944; BYTE $0xd2
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rcx
	LONG $0x03e9c148
	// movzbl (%rcx,%rax,1),%ebx
	LONG $0x011cb60f
	// shrx   %edx,%ebx,%edi
	LONG $0xf76be2c4; BYTE $0xfb
	// bts    %edx,%ebx
	WORD $0xab0f; BYTE $0xd3
	// mov    %bl,(%rcx,%rax,1)
	WORD $0x1c88; BYTE $0x01
	// bzhi   %r15d,%esi,%ecx
	LONG $0xf500e2c4; BYTE $0xce
	// movzwl %cx,%edx
	WORD $0xb70f; BYTE $0xd1
	// and    $0x7,%cl
	WORD $0xe180; BYTE $0x07
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%esi
	LONG $0x0234b60f
	// shrx   %ecx,%esi,%ebx
	LONG $0xf773e2c4; BYTE $0xde
	// and    %edi,%ebx
	WORD $0xfb21
	// bts    %ecx,%esi
	WORD $0xab0f; BYTE $0xce
	// mov    %sil,(%rdx,%rax,1)
	LONG $0x02348840
	// bzhi   %r15d,%r9d,%ecx
	LONG $0xf500c2c4; BYTE $0xc9
	// movzwl %cx,%edx
	WORD $0xb70f; BYTE $0xd1
	// and    $0x7,%cl
	WORD $0xe180; BYTE $0x07
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%esi
	LONG $0x0234b60f
	// shrx   %ecx,%esi,%r9d
	LONG $0xf77362c4; BYTE $0xce
	// bts    %ecx,%esi
	WORD $0xab0f; BYTE $0xce
	// mov    %sil,(%rdx,%rax,1)
	LONG $0x02348840
	// bzhi   %r15d,%r11d,%edx
	LONG $0xf500c2c4; BYTE $0xd3
	// mov    %edx,%esi
	WORD $0xd689
	// and    $0x7,%sil
	LONG $0x07e68040
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%edi
	LONG $0x023cb60f
	// shrx   %esi,%edi,%ecx
	LONG $0xf74be2c4; BYTE $0xcf
	// and    %r9d,%ecx
	WORD $0x2144; BYTE $0xc9
	// and    %ebx,%ecx
	WORD $0xd921
	// bts    %esi,%edi
	WORD $0xab0f; BYTE $0xf7
	// mov    %dil,(%rdx,%rax,1)
	LONG $0x023c8840
	// movzwl %r14w,%edx
	LONG $0xd6b70f41
	// mov    %r14d,%esi
	WORD $0x8944; BYTE $0xf6
	// and    $0x7,%sil
	LONG $0x07e68040
	// shr    $0x3,%rdx
	LONG $0x03eac148
	// movzbl (%rdx,%rax,1),%edi
	LONG $0x023cb60f
	// shrx   %esi,%edi,%ebx
	LONG $0xf74be2c4; BYTE $0xdf
	// bts    %esi,%edi
	WORD $0xab0f; BYTE $0xf7
	// mov    %dil,(%rdx,%rax,1)
	LONG $0x023c8840
	// bzhi   %r15d,%ebp,%edx
	LONG $0xf500e2c4; BYTE $0xd5
	// movzwl %dx,%esi
	WORD $0xb70f; BYTE $0xf2
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%edi
	LONG $0x063cb60f
	// shrx   %edx,%edi,%ebp
	LONG $0xf76be2c4; BYTE $0xef
	// and    %ebx,%ebp
	WORD $0xdd21
	// bts    %edx,%edi
	WORD $0xab0f; BYTE $0xd7
	// mov    %dil,(%rsi,%rax,1)
	LONG $0x063c8840
	// bzhi   %r15d,%r8d,%edx
	LONG $0xf500c2c4; BYTE $0xd0
	// movzwl %dx,%esi
	WORD $0xb70f; BYTE $0xf2
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%edi
	LONG $0x063cb60f
	// shrx   %edx,%edi,%ebx
	LONG $0xf76be2c4; BYTE $0xdf
	// and    %ebp,%ebx
	WORD $0xeb21
	// and    %ecx,%ebx
	WORD $0xcb21
	// bts    %edx,%edi
	WORD $0xab0f; BYTE $0xd7
	// mov    %dil,(%rsi,%rax,1)
	LONG $0x063c8840
	// test   $0x1,%bl
	WORD $0xc3f6; BYTE $0x01
	// sete   %al
	WORD $0x940f; BYTE $0xc0
	// add    $0x8,%rsp
	LONG $0x08c48348
	// pop    %rbx
	BYTE $0x5b
	// pop    %r14
	WORD $0x5e41
	// pop    %r15
	WORD $0x5f41
	// pop    %rbp
	BYTE $0x5d
	// ret    
	BYTE $0xc3

TEXT PBF7_Test(SB), NOSPLIT, $0
	// push   %rbp
	BYTE $0x55
	// push   %r15
	WORD $0x5741
	// push   %r14
	WORD $0x5641
	// push   %rbx
	BYTE $0x53
	// push   %rax
	BYTE $0x50
	// mov    %edx,%r15d
	WORD $0x8941; BYTE $0xd7
	// mov    %esi,%ebx
	WORD $0xf389
	// mov    %rdi,%r14
	WORD $0x8949; BYTE $0xfe
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// mov    %r8d,%esi
	WORD $0x8944; BYTE $0xc6
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	WORD $0x8948; BYTE $0xc1
	// mov    %rdx,%rbp
	WORD $0x8948; BYTE $0xd5
	// rorx   $0x6,%ecx,%edx
	LONG $0xf07be3c4; WORD $0x06d1
	// mov    %rax,%rdi
	WORD $0x8948; BYTE $0xc7
	// shr    $0x20,%rdi
	LONG $0x20efc148
	// rorx   $0x2,%ebp,%eax
	LONG $0xf07be3c4; WORD $0x02c5
	// mov    %rbp,%rsi
	WORD $0x8948; BYTE $0xee
	// shr    $0x20,%rsi
	LONG $0x20eec148
	// rorx   $0x4,%edi,%edi
	LONG $0xf07be3c4; WORD $0x04ff
	// xor    %edx,%eax
	WORD $0xd031
	// xor    %esi,%eax
	WORD $0xf031
	// xor    %edi,%eax
	WORD $0xf831
	// xor    %edx,%edx
	WORD $0xd231
	// div    %r15d
	WORD $0xf741; BYTE $0xf7
	// vmovq  %rbp,%xmm0
	LONG $0x6ef9e1c4; BYTE $0xc5
	// vmovq  %rcx,%xmm1
	LONG $0x6ef9e1c4; BYTE $0xc9
	// shlx   %rbx,%rdx,%rax
	LONG $0xf7e1e2c4; BYTE $0xc2
	// add    %r14,%rax
	WORD $0x014c; BYTE $0xf0
	// vpunpcklqdq %xmm0,%xmm1,%xmm0
	LONG $0xc06cf1c5
	// add    $0x3,%bl
	WORD $0xc380; BYTE $0x03
	// mov    $0xffffffff,%ecx
	LONG $0xffffffb9; BYTE $0xff
	// shlx   %ebx,%ecx,%ecx
	LONG $0xf761e2c4; BYTE $0xc9
	// not    %ecx
	WORD $0xd1f7
	// vmovd  %ecx,%xmm1
	LONG $0xc96ef9c5
	// vpbroadcastd %xmm1,%ymm1
	LONG $0x587de2c4; BYTE $0xc9
	// vpsrld $0x10,%xmm0,%xmm2
	LONG $0xd072e9c5; BYTE $0x10
	// vinserti128 $0x1,%xmm2,%ymm0,%ymm0
	LONG $0x387de3c4; WORD $0x01c2
	// vpand  %ymm0,%ymm1,%ymm0
	LONG $0xc0dbf5c5
	// vpsrld $0x5,%ymm0,%ymm1
	LONG $0xd072f5c5; BYTE $0x05
	// vmovdqa 0x4b(%rip),%ymm2        # c40 <PBF7_Test+0xe0>
	QUAD $0x0000004b156ffdc5
	// vpcmpeqd %ymm3,%ymm3,%ymm3
	LONG $0xdb76e5c5
	// vpgatherdd %ymm2,(%rax,%ymm1,4),%ymm3
	LONG $0x906de2c4; WORD $0x881c
	// vpbroadcastd 0x58(%rip),%ymm1        # c60 <PBF7_Test+0x100>
	QUAD $0x0000580d587de2c4; BYTE $0x00
	// vpand  %ymm1,%ymm0,%ymm0
	LONG $0xc1dbfdc5
	// vpbroadcastd 0x4f(%rip),%ymm1        # c64 <PBF7_Test+0x104>
	QUAD $0x00004f0d587de2c4; BYTE $0x00
	// vpsllvd %ymm0,%ymm1,%ymm0
	LONG $0x4775e2c4; BYTE $0xc0
	// vpandn %ymm0,%ymm3,%ymm1
	LONG $0xc8dfe5c5
	// vptest %ymm0,%ymm1
	LONG $0x177de2c4; BYTE $0xc8
	// sete   %al
	WORD $0x940f; BYTE $0xc0
	// add    $0x8,%rsp
	LONG $0x08c48348
	// pop    %rbx
	BYTE $0x5b
	// pop    %r14
	WORD $0x5e41
	// pop    %r15
	WORD $0x5f41
	// pop    %rbp
	BYTE $0x5d
	// vzeroupper 
	WORD $0xf8c5; BYTE $0x77
	// ret    
	BYTE $0xc3
	// data 52
	QUAD $0x0000841f0f2e6666; QUAD $0xffffffff90000000; QUAD $0xffffffffffffffff; QUAD $0xffffffffffffffff; QUAD $0xffffffffffffffff; QUAD $0x0000001f00000000; LONG $0x00000001

TEXT PBF8_Set(SB), NOSPLIT, $0
	// push   %rbp
	BYTE $0x55
	// push   %r15
	WORD $0x5741
	// push   %r14
	WORD $0x5641
	// push   %r12
	WORD $0x5441
	// push   %rbx
	BYTE $0x53
	// mov    %edx,%ebp
	WORD $0xd589
	// mov    %esi,%r15d
	WORD $0x8941; BYTE $0xf7
	// mov    %rdi,%r14
	WORD $0x8949; BYTE $0xfe
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// mov    %r8d,%esi
	WORD $0x8944; BYTE $0xc6
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rsi
	WORD $0x8948; BYTE $0xc6
	// mov    %rdx,%rcx
	WORD $0x8948; BYTE $0xd1
	// mov    %rax,%r10
	WORD $0x8949; BYTE $0xc2
	// shr    $0x20,%r10
	LONG $0x20eac149
	// mov    %rdx,%r8
	WORD $0x8949; BYTE $0xd0
	// shr    $0x20,%r8
	LONG $0x20e8c149
	// rorx   $0x6,%esi,%edx
	LONG $0xf07be3c4; WORD $0x06d6
	// rorx   $0x4,%r10d,%edi
	LONG $0xf07bc3c4; WORD $0x04fa
	// rorx   $0x2,%ecx,%eax
	LONG $0xf07be3c4; WORD $0x02c1
	// xor    %edx,%eax
	WORD $0xd031
	// xor    %r8d,%eax
	WORD $0x3144; BYTE $0xc0
	// xor    %edi,%eax
	WORD $0xf831
	// xor    %edx,%edx
	WORD $0xd231
	// div    %ebp
	WORD $0xf5f7
	// shlx   %r15,%rdx,%rax
	LONG $0xf781e2c4; BYTE $0xc2
	// add    %r14,%rax
	WORD $0x014c; BYTE $0xf0
	// mov    %rsi,%r14
	WORD $0x8949; BYTE $0xf6
	// add    $0x3,%r15b
	LONG $0x03c78041
	// bzhi   %r15d,%esi,%r11d
	LONG $0xf50062c4; BYTE $0xde
	// shr    $0x10,%rsi
	LONG $0x10eec148
	// shr    $0x30,%r14
	LONG $0x30eec149
	// mov    %rcx,%r9
	WORD $0x8949; BYTE $0xc9
	// bzhi   %r15d,%ecx,%r12d
	LONG $0xf50062c4; BYTE $0xe1
	// mov    %rcx,%rdx
	WORD $0x8948; BYTE $0xca
	// shr    $0x10,%rdx
	LONG $0x10eac148
	// shr    $0x30,%r9
	LONG $0x30e9c149
	// movzwl %r11w,%ecx
	LONG $0xcbb70f41
	// mov    %r11d,%ebp
	WORD $0x8944; BYTE $0xdd
	// and    $0x7,%bpl
	LONG $0x07e58040
	// shr    $0x3,%rcx
	LONG $0x03e9c148
	// movzbl (%rcx,%rax,1),%ebx
	LONG $0x011cb60f
	// shrx   %ebp,%ebx,%edi
	LONG $0xf753e2c4; BYTE $0xfb
	// bts    %ebp,%ebx
	WORD $0xab0f; BYTE $0xeb
	// mov    %bl,(%rcx,%rax,1)
	WORD $0x1c88; BYTE $0x01
	// bzhi   %r15d,%esi,%ecx
	LONG $0xf500e2c4; BYTE $0xce
	// movzwl %cx,%esi
	WORD $0xb70f; BYTE $0xf1
	// and    $0x7,%cl
	WORD $0xe180; BYTE $0x07
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%ebp
	LONG $0x062cb60f
	// shrx   %ecx,%ebp,%ebx
	LONG $0xf773e2c4; BYTE $0xdd
	// and    %edi,%ebx
	WORD $0xfb21
	// bts    %ecx,%ebp
	WORD $0xab0f; BYTE $0xcd
	// mov    %bpl,(%rsi,%rax,1)
	LONG $0x062c8840
	// bzhi   %r15d,%r10d,%ecx
	LONG $0xf500c2c4; BYTE $0xca
	// movzwl %cx,%esi
	WORD $0xb70f; BYTE $0xf1
	// and    $0x7,%cl
	WORD $0xe180; BYTE $0x07
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%edi
	LONG $0x063cb60f
	// shrx   %ecx,%edi,%r10d
	LONG $0xf77362c4; BYTE $0xd7
	// bts    %ecx,%edi
	WORD $0xab0f; BYTE $0xcf
	// mov    %dil,(%rsi,%rax,1)
	LONG $0x063c8840
	// bzhi   %r15d,%r14d,%esi
	LONG $0xf500c2c4; BYTE $0xf6
	// mov    %esi,%edi
	WORD $0xf789
	// and    $0x7,%dil
	LONG $0x07e78040
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%ebp
	LONG $0x062cb60f
	// shrx   %edi,%ebp,%ecx
	LONG $0xf743e2c4; BYTE $0xcd
	// and    %r10d,%ecx
	WORD $0x2144; BYTE $0xd1
	// and    %ebx,%ecx
	WORD $0xd921
	// bts    %edi,%ebp
	WORD $0xab0f; BYTE $0xfd
	// mov    %bpl,(%rsi,%rax,1)
	LONG $0x062c8840
	// movzwl %r12w,%esi
	LONG $0xf4b70f41
	// mov    %r12d,%edi
	WORD $0x8944; BYTE $0xe7
	// and    $0x7,%dil
	LONG $0x07e78040
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%ebp
	LONG $0x062cb60f
	// shrx   %edi,%ebp,%ebx
	LONG $0xf743e2c4; BYTE $0xdd
	// bts    %edi,%ebp
	WORD $0xab0f; BYTE $0xfd
	// mov    %bpl,(%rsi,%rax,1)
	LONG $0x062c8840
	// bzhi   %r15d,%edx,%edx
	LONG $0xf500e2c4; BYTE $0xd2
	// movzwl %dx,%esi
	WORD $0xb70f; BYTE $0xf2
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%edi
	LONG $0x063cb60f
	// shrx   %edx,%edi,%ebp
	LONG $0xf76be2c4; BYTE $0xef
	// and    %ebx,%ebp
	WORD $0xdd21
	// bts    %edx,%edi
	WORD $0xab0f; BYTE $0xd7
	// mov    %dil,(%rsi,%rax,1)
	LONG $0x063c8840
	// bzhi   %r15d,%r8d,%edx
	LONG $0xf500c2c4; BYTE $0xd0
	// movzwl %dx,%esi
	WORD $0xb70f; BYTE $0xf2
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rsi
	LONG $0x03eec148
	// movzbl (%rsi,%rax,1),%edi
	LONG $0x063cb60f
	// shrx   %edx,%edi,%ebx
	LONG $0xf76be2c4; BYTE $0xdf
	// and    %ebp,%ebx
	WORD $0xeb21
	// and    %ecx,%ebx
	WORD $0xcb21
	// bts    %edx,%edi
	WORD $0xab0f; BYTE $0xd7
	// mov    %dil,(%rsi,%rax,1)
	LONG $0x063c8840
	// bzhi   %r15d,%r9d,%ecx
	LONG $0xf500c2c4; BYTE $0xc9
	// mov    %ecx,%edx
	WORD $0xca89
	// and    $0x7,%dl
	WORD $0xe280; BYTE $0x07
	// shr    $0x3,%rcx
	LONG $0x03e9c148
	// movzbl (%rcx,%rax,1),%esi
	LONG $0x0134b60f
	// shrx   %edx,%esi,%edi
	LONG $0xf76be2c4; BYTE $0xfe
	// and    %ebx,%edi
	WORD $0xdf21
	// bts    %edx,%esi
	WORD $0xab0f; BYTE $0xd6
	// mov    %sil,(%rcx,%rax,1)
	LONG $0x01348840
	// test   $0x1,%dil
	LONG $0x01c7f640
	// sete   %al
	WORD $0x940f; BYTE $0xc0
	// pop    %rbx
	BYTE $0x5b
	// pop    %r12
	WORD $0x5c41
	// pop    %r14
	WORD $0x5e41
	// pop    %r15
	WORD $0x5f41
	// pop    %rbp
	BYTE $0x5d
	// ret    
	BYTE $0xc3

TEXT PBF8_Test(SB), NOSPLIT, $0
	// push   %rbp
	BYTE $0x55
	// push   %r15
	WORD $0x5741
	// push   %r14
	WORD $0x5641
	// push   %rbx
	BYTE $0x53
	// push   %rax
	BYTE $0x50
	// mov    %edx,%r15d
	WORD $0x8941; BYTE $0xd7
	// mov    %esi,%ebx
	WORD $0xf389
	// mov    %rdi,%r14
	WORD $0x8949; BYTE $0xfe
	// mov    %rcx,%rdi
	WORD $0x8948; BYTE $0xcf
	// mov    %r8d,%esi
	WORD $0x8944; BYTE $0xc6
	// call   0 <_ZN3pbf4HashEPKhj>
	CALL _ZN3pbf4HashEPKhj(SB)
	// mov    %rax,%rcx
	WORD $0x8948; BYTE $0xc1
	// mov    %rdx,%rbp
	WORD $0x8948; BYTE $0xd5
	// rorx   $0x6,%ecx,%edx
	LONG $0xf07be3c4; WORD $0x06d1
	// mov    %rax,%rdi
	WORD $0x8948; BYTE $0xc7
	// shr    $0x20,%rdi
	LONG $0x20efc148
	// rorx   $0x2,%ebp,%eax
	LONG $0xf07be3c4; WORD $0x02c5
	// mov    %rbp,%rsi
	WORD $0x8948; BYTE $0xee
	// shr    $0x20,%rsi
	LONG $0x20eec148
	// rorx   $0x4,%edi,%edi
	LONG $0xf07be3c4; WORD $0x04ff
	// xor    %edx,%eax
	WORD $0xd031
	// xor    %esi,%eax
	WORD $0xf031
	// xor    %edi,%eax
	WORD $0xf831
	// xor    %edx,%edx
	WORD $0xd231
	// div    %r15d
	WORD $0xf741; BYTE $0xf7
	// vmovq  %rbp,%xmm0
	LONG $0x6ef9e1c4; BYTE $0xc5
	// vmovq  %rcx,%xmm1
	LONG $0x6ef9e1c4; BYTE $0xc9
	// shlx   %rbx,%rdx,%rax
	LONG $0xf7e1e2c4; BYTE $0xc2
	// add    %r14,%rax
	WORD $0x014c; BYTE $0xf0
	// vpunpcklqdq %xmm0,%xmm1,%xmm0
	LONG $0xc06cf1c5
	// add    $0x3,%bl
	WORD $0xc380; BYTE $0x03
	// mov    $0xffffffff,%ecx
	LONG $0xffffffb9; BYTE $0xff
	// shlx   %ebx,%ecx,%ecx
	LONG $0xf761e2c4; BYTE $0xc9
	// not    %ecx
	WORD $0xd1f7
	// vmovd  %ecx,%xmm1
	LONG $0xc96ef9c5
	// vpbroadcastd %xmm1,%ymm1
	LONG $0x587de2c4; BYTE $0xc9
	// vpsrld $0x10,%xmm0,%xmm2
	LONG $0xd072e9c5; BYTE $0x10
	// vinserti128 $0x1,%xmm2,%ymm0,%ymm0
	LONG $0x387de3c4; WORD $0x01c2
	// vpand  %ymm0,%ymm1,%ymm0
	LONG $0xc0dbf5c5
	// vpsrld $0x5,%ymm0,%ymm1
	LONG $0xd072f5c5; BYTE $0x05
	// vpcmpeqd %ymm2,%ymm2,%ymm2
	LONG $0xd276edc5
	// vpxor  %xmm3,%xmm3,%xmm3
	LONG $0xdbefe1c5
	// vpgatherdd %ymm2,(%rax,%ymm1,4),%ymm3
	LONG $0x906de2c4; WORD $0x881c
	// vpbroadcastd 0x2c(%rip),%ymm1        # ef0 <PBF8_Test+0xd0>
	QUAD $0x00002c0d587de2c4; BYTE $0x00
	// vpand  %ymm1,%ymm0,%ymm0
	LONG $0xc1dbfdc5
	// vpbroadcastd 0x23(%rip),%ymm1        # ef4 <PBF8_Test+0xd4>
	QUAD $0x0000230d587de2c4; BYTE $0x00
	// vpsllvd %ymm0,%ymm1,%ymm0
	LONG $0x4775e2c4; BYTE $0xc0
	// vpandn %ymm0,%ymm3,%ymm1
	LONG $0xc8dfe5c5
	// vptest %ymm0,%ymm1
	LONG $0x177de2c4; BYTE $0xc8
	// sete   %al
	WORD $0x940f; BYTE $0xc0
	// add    $0x8,%rsp
	LONG $0x08c48348
	// pop    %rbx
	BYTE $0x5b
	// pop    %r14
	WORD $0x5e41
	// pop    %r15
	WORD $0x5f41
	// pop    %rbp
	BYTE $0x5d
	// vzeroupper 
	WORD $0xf8c5; BYTE $0x77
	// ret    
	BYTE $0xc3
	// data 8
	QUAD $0x000000010000001f

