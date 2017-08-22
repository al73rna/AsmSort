.386
.MODEL FLAT
.STACK 10000
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
INCLUDE io.h

.DATA
array		DWORD	83,21,33,10,90,2
;newarray	DWORD	5 DUP (?)
outstring	BYTE	11 DUP (?)
			BYTE	0dh,0ah,0

.CODE
_main:
			lea		ebx, array
			push	ebx
			call	insertion
			add		esp, 4
			mov		ecx, 0				; length of array
print:		cmp		ecx, 6
			jae		done
			mov		eax,ecx
			shl		eax,2
			dtoa	outstring, [ebx+eax]
			output	outstring
			inc		ecx
			jmp		print
done:		invoke	ExitProcess, 0

insertion	PROC
			push	ebp
			mov		ebp, esp
			push	eax
			push	ebx
			push	ecx
			push	edx
			push	esi
			pushfd
			mov		esi, [ebp+8]
			mov		edx, 1
fori:		cmp		edx, 6				; length of array is 6
			jge		finish
			mov		ecx, edx
			dec		ecx
forj:		cmp		ecx, 0
			jl		looper2
			mov		edi, ecx
			shl		edi,2
			mov		eax, [esi+edi+4]
			mov		ebx, [esi+edi]
			cmp		eax, ebx
			jng		looper
			mov		[esi+edi+4], ebx
			mov		[esi+edi], eax
looper:		dec		ecx
			jmp		forj
looper2:	inc		edx
			jmp		fori
finish:		
			popfd
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax
			pop		ebp
			ret
insertion	ENDP
public	_main
END