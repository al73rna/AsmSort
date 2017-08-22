.386
.MODEL FLAT
.STACK 10000
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
INCLUDE io.h

.DATA
array		DWORD	-83,21,33,10,90,2
outstring	BYTE	11 DUP (?)
			BYTE	0dh,0ah,0


.CODE
_main:
			lea		ebx, array
			push	ebx
			call	selection
			add		esp, 4
			mov		ecx, 0				; length of array is 6
print:		cmp		ecx, 6
			jae		done
			mov		eax,ecx
			shl		eax,2
			dtoa	outstring, [ebx+eax]
			output	outstring
			inc		ecx
			jmp		print
done:		invoke	ExitProcess, 0

selection	PROC
			push	ebp
			mov		ebp, esp
			SUB		eSp, 4
			push	eax
			push	ebx
			push	ecx
			push	edx
			push	esi
			pushfd
			
			mov		ecx, 5				; length of array
			mov		esi, [ebp+8]
fori:		cmp		ecx, 0
			jle		finish
			mov		dword ptr [ebp-4], 0
			mov		edx, 1
forj:		cmp		edx, ecx
			jg		looper
			mov		edi,edx
			shl		edi, 1
			add		edi, edi
			mov		eax,[esi+edi]
			mov		edi, [ebp-4]
			shl		edi, 1
			add		edi, edi
			mov		ebx, [esi+edi]
			cmp		eax, ebx
			jng		looper2
			mov		[ebp-4], edx
looper2:	inc		edx
			jmp		forj
looper:		
			mov		edi,[ebp-4]			; swap
			shl		edi, 1
			add		edi, edi
			mov		eax,[esi+edi]		; a[maxindex] is in eax
			mov		edi, ecx
			shl		edi, 1
			add		edi, edi
			mov		ebx, [esi+edi]		;a[i] is in ebx
			mov		[esi+edi], eax
			mov		edi,[ebp-4]
			shl		edi, 2
			mov		[esi+edi], ebx
			dec		ecx
			jmp		fori
finish:
			popfd
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax
			mov		esp, ebp
			pop		ebp
			ret
selection	ENDP
PUBLIC	_main
END

				