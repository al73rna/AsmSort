.386
.MODEL FLAT
.STACK 40960
ExitProcess PROTO NEAR32 stdcall ,dwExitCode:DWORD

include io.h

.DATA
array		dword	45 ,633 ,11 ,2 ,140 ,98 , 94 DUP (?)
outstring	BYTE	11 DUP (?)
			BYTE	0Dh,0Ah,0


.CODE
main:
			lea		ebx ,array
			push	ebx
			call	bubblesort
			add		esp ,4
			lea		ebx ,array
			mov		ecx ,5
print:		
			dtoa	outstring ,[ebx]
			output	outstring
			add		ebx ,4
			loop	print
			invoke	ExitProcess ,0
			
bubblesort	PROC
			push	ebp
			mov		ebp ,esp
			push	eax
			push	ebx
			push	ecx
			push	edx
			mov		ecx ,5		; i
			jecxz	endfori
			mov		eax ,[ebp+8]
fori:		mov		edx ,0				; j
forj:		cmp		edx ,ecx
			je		endforj	
			mov		ebx , [eax]	
			cmp		ebx ,[eax+4]
			jng		ng
			mov		esi , [eax+4]
			mov		[eax+4] , ebx
			mov		[eax] ,esi
ng:			
			add		eax ,4
			inc		edx
			jmp		forj
endforj:	
			mov		eax ,[ebp+8]
			loop	fori
endfori:	pop		edx
			pop		ecx
			pop		ebx
			pop		eax
			pop		ebp
			ret
bubblesort	ENDP

public main
END