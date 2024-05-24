// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "textflag.h"

TEXT ·pbf4Set(SB), NOSPLIT, $120
	MOVQ space+0(FP), DI
	MOVQ pageLevel+8(FP), SI
	MOVQ pageNum+16(FP), DX
	MOVQ key+24(FP), CX
	MOVQ key_len+32(FP), R8
	CALL PBF4_Set(SB)
	MOVB AX, ret+40(FP)
	RET

TEXT ·pbf4Test(SB), NOSPLIT, $120
	MOVQ space+0(FP), DI
	MOVQ pageLevel+8(FP), SI
	MOVQ pageNum+16(FP), DX
	MOVQ key+24(FP), CX
	MOVQ key_len+32(FP), R8
	CALL PBF4_Test(SB)
	MOVB AX, ret+40(FP)
	RET

TEXT ·pbf5Set(SB), NOSPLIT, $120
	MOVQ space+0(FP), DI
	MOVQ pageLevel+8(FP), SI
	MOVQ pageNum+16(FP), DX
	MOVQ key+24(FP), CX
	MOVQ key_len+32(FP), R8
	CALL PBF5_Set(SB)
	MOVB AX, ret+40(FP)
	RET

TEXT ·pbf5Test(SB), NOSPLIT, $120
	MOVQ space+0(FP), DI
	MOVQ pageLevel+8(FP), SI
	MOVQ pageNum+16(FP), DX
	MOVQ key+24(FP), CX
	MOVQ key_len+32(FP), R8
	CALL PBF5_Test(SB)
	MOVB AX, ret+40(FP)
	RET

TEXT ·pbf6Set(SB), NOSPLIT, $120
	MOVQ space+0(FP), DI
	MOVQ pageLevel+8(FP), SI
	MOVQ pageNum+16(FP), DX
	MOVQ key+24(FP), CX
	MOVQ key_len+32(FP), R8
	CALL PBF6_Set(SB)
	MOVB AX, ret+40(FP)
	RET

TEXT ·pbf6Test(SB), NOSPLIT, $120
	MOVQ space+0(FP), DI
	MOVQ pageLevel+8(FP), SI
	MOVQ pageNum+16(FP), DX
	MOVQ key+24(FP), CX
	MOVQ key_len+32(FP), R8
	CALL PBF6_Test(SB)
	MOVB AX, ret+40(FP)
	RET

TEXT ·pbf7Set(SB), NOSPLIT, $120
	MOVQ space+0(FP), DI
	MOVQ pageLevel+8(FP), SI
	MOVQ pageNum+16(FP), DX
	MOVQ key+24(FP), CX
	MOVQ key_len+32(FP), R8
	CALL PBF7_Set(SB)
	MOVB AX, ret+40(FP)
	RET

TEXT ·pbf7Test(SB), NOSPLIT, $120
	MOVQ space+0(FP), DI
	MOVQ pageLevel+8(FP), SI
	MOVQ pageNum+16(FP), DX
	MOVQ key+24(FP), CX
	MOVQ key_len+32(FP), R8
	CALL PBF7_Test(SB)
	MOVB AX, ret+40(FP)
	RET

TEXT ·pbf8Set(SB), NOSPLIT, $120
	MOVQ space+0(FP), DI
	MOVQ pageLevel+8(FP), SI
	MOVQ pageNum+16(FP), DX
	MOVQ key+24(FP), CX
	MOVQ key_len+32(FP), R8
	CALL PBF8_Set(SB)
	MOVB AX, ret+40(FP)
	RET

TEXT ·pbf8Test(SB), NOSPLIT, $120
	MOVQ space+0(FP), DI
	MOVQ pageLevel+8(FP), SI
	MOVQ pageNum+16(FP), DX
	MOVQ key+24(FP), CX
	MOVQ key_len+32(FP), R8
	CALL PBF8_Test(SB)
	MOVB AX, ret+40(FP)
	RET
