.386
.MODEL FLAT
.STACK 4096
ExitProcess PROTO NEAR32 stdcall, dwExitCode:dword
include io.h

.DATA
array		DWORD	-8,0,12,70,110,155,199,778
prompt		BYTE	"Please input the number to search: ",0
instring	BYTE	11 DUP (?)
foundtext	BYTE	"Yoyr number is in index:"
outstring	BYTE	11 DUP (?)
			BYTE	0dh,0ah,0
notfoundtext	BYTE	"NOT FOUND!",0dh,0ah,0

.CODE
_main:
			output	prompt
			input	instring, 11
			atod	instring
			push	eax
			mov		eax, 7
			push	eax
			mov		eax, 0
			push	eax
			lea		eax, array
			push	eax
			call	search
			add		esp, 12
			cmp		eax, -1
			je		notfound
			dtoa	outstring, eax
			output	foundtext
			jmp		done
notfound:
			output	notfoundtext
done:		
			invoke	ExitProcess, 0
			

search		PROC
			push	ebp
			mov		ebp, esp
			push	ebx
			push	ecx
			push	edx
			push	esi
			pushfd

			mov		ecx, [ebp+12]		; first
			mov		edx, [ebp+16]		; last
			cmp		ecx, edx
			jle		else1
			mov		eax, -1
			jmp		finishproc
else1:		
			sub		edx,ecx
			shr		edx, 1
			add		edx, ecx
			mov		ecx, edx			; edx contains mid
			shl		ecx, 2
			mov		esi, [ebp+8]
			mov		esi, [esi+ecx]
			cmp		esi, [ebp+20]
			jg		else2
			jl		else3
			mov		eax, edx			; if equal
			jmp		finishproc
else2:		
			push	[ebp+20]
			mov		ecx, edx
			dec		ecx
			push	ecx
			push	[ebp+12]
			push	[ebp+8]
			call	search
			add		esp, 16
			jmp		finishproc
else3:
			push	[ebp+20]
			mov		ecx, edx
			inc		ecx
			push	[ebp+16]
			push	ecx
			push	[ebp+8]
			call	search
			add		esp, 16
			jmp		finishproc

finishproc:	
			popfd
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			pop		ebp
			ret
search		ENDP
public	_main
END

