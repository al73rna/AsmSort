.386
.MODEL FLAT
.STACK 10000
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
INCLUDE io.h

.DATA
array		DWORD	83,-21,33,10,90,2
newarray	DWORD	6 DUP (?)
outstring	BYTE	11 DUP (?)
			BYTE	0dh,0ah,0

.CODE
_main:
			mov		ebx, 5
			push	ebx
			mov		ebx, 0
			push	ebx
			lea		ebx, array
			push	ebx
			call	sort
			add		esp, 12
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

sort		PROC
			push	ebp
			mov		ebp, esp
			push	eax
			push	ebx
			push	ecx
			push	edx
			pushfd

			mov		eax, [ebp+12]
			mov		ebx, [ebp+16]
			cmp		eax, ebx
			jae		endsort

			push	[ebp+16]			
			push	[ebp+12]
			push	[ebp+8]
			call	partition
			add		esp, 12
			
			mov		ebx, eax
			dec		ebx
			push	ebx
			push	[ebp+12]
			push	[ebp+8]
			call	sort
			add		esp, 12

			mov		ebx, eax
			inc		ebx
			push	[ebp+16]
			push	ebx
			push	[ebp+8]
			call	sort
			add		esp, 12
endsort:
			popfd
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax
			pop		ebp
			ret
sort		ENDP
			

partition	PROC
			push	ebp
			mov		ebp, esp
			push	ebx
			push	ecx
			push	edx
			push	esi
			push	edi
			pushfd

			mov		ecx, [ebp+12]
			mov		edx, [ebp+16]
mainwhile:	cmp		ecx, edx
			jae		endmainwhile

while1:		mov		eax, [ebp+8]
			mov		ebx, ecx
			shl		ebx, 2
			mov		esi, [eax+ebx]
			mov		ebx, [ebp+12]
			shl		ebx, 2
			cmp		esi, [eax+ebx]
			jg		nextwhile
			inc		ecx
			jmp		while1
nextwhile:
while2: 	mov		eax, [ebp+8]
			mov		ebx, edx
			shl		ebx, 2
			mov		esi, [eax+ebx]
			mov		ebx, [ebp+12]
			shl		ebx, 2
			cmp		esi, [eax+ebx]
			jle		endwhile2
			dec		edx
			jmp		while2
endwhile2:
			cmp		ecx, edx
			jge		whileloop
			mov		eax, [ebp+8]
			mov		ebx, ecx
			shl		ebx, 2
			mov		esi, [eax+ebx]
			mov		ebx, edx
			shl		ebx, 2
			mov		edi, [eax+ebx]
			mov		DWORD PTR [eax+ebx], esi
			mov		ebx, ecx
			shl		ebx, 2
			mov		DWORD PTR [eax+ebx], edi
whileloop:
			jmp		mainwhile
endmainwhile:
			mov		eax, [ebp+8]
			mov		ebx, [ebp+12]
			shl		ebx, 2
			mov		esi, [eax+ebx]
			mov		ebx, edx
			shl		ebx, 2
			mov		edi, [eax+ebx]
			mov		DWORD PTR [eax+ebx], esi
			mov		ebx, [ebp+12]
			shl		ebx, 2
			mov		DWORD PTR [eax+ebx], edi
			mov		eax, edx
			popfd
			pop		edi
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			pop		ebp
			ret
partition	ENDP

public	_main
END
