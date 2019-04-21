.386
.MODEL flat, stdcall
.STACK 4096

include msvcrt.inc
includelib msvcrt.lib

.data

array DWORD 13h, 11h, 15h, 9h, 23h, 1h, 43h, 45h, 23h, 23h, 12h

.code
;==================================================================
;==================================================================
insertionSort PROC
   push ebp
   mov ebp, esp
   sub esp, 12
   
   push eax
   push ebx
   push ecx
   push esi
   push edi

   xor ecx, ecx
   inc ecx
   mov[ebp-4], ecx ; i = 1
   jmp first_for_jmp
   ;----------------------------------------------------------------------
for_loop:
   mov ecx, [ebp-4]
   inc ecx
   mov [ebp-4], ecx; i++
first_for_jmp:
   cmp ecx, [ebp+12]
   jge exit_first_for
   mov eax, [ebp+8]
   mov esi, [eax+ecx*4]
   mov [ebp-8], esi;  key = arr[i]
   
   mov edi, ecx
   dec edi
   mov [ebp-12], edi; j = i - 1
   ;---------------------------------------------------------------------
while_loop:
   cmp edi, 0
   jl exit_while
   mov eax, [ebp+8]
   mov esi, [eax+edi*4];arr[j]
   cmp esi, [ebp-8]
   jle exit_while
   
   mov ecx, [eax+edi*4]
   mov [eax+edi*4+4], ecx;arr[j+1] = arr[j]
   
   mov edi, [ebp-12]
   dec edi
   mov [ebp-12], edi; j = j-1
   jmp while_loop
   ;----------------------------------------------------------------------
exit_while:
   mov ecx, [ebp-8]
   mov [eax+edi*4+4], ecx;arr[j+1] = key
   
jmp for_loop
   ;----------------------------------------------------------------------
exit_first_for:
   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax

   add esp, 12
   pop ebp
   ret 8
insertionSort ENDP

;==================================================================
;==================================================================
main PROC
   push ebp
   mov ebp, esp
   sub esp, 32 ;Allocate memory

   push 11
   push offset array
   call insertionSort
   mov eax, eax;In eax is the returned index
   add esp, 32
   pop ebp
   ret
main ENDP
END main
