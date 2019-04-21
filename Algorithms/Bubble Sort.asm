.386
.MODEL flat, stdcall
.STACK 4096

include msvcrt.inc
includelib msvcrt.lib

.data

array DWORD 13h, 11h, 15h, 9h, 23h, 1h, 43h, 45h, 23h, 23h, 12h

.code

swap PROC
   push ebp
   mov ebp, esp
   sub esp, 4

   push eax
   push ebx

   mov eax, [ebp+8]
   mov eax, [eax]
   mov [ebp-4], eax; int temp = *xp
   
   mov ebx, [ebp+12]
   mov ebx, [ebx]; *yp
   mov eax, [ebp+8]
   mov [eax], ebx;*xp = *yp 

   mov eax, [ebp-4];*xp

   mov ebx, [ebp+12]
   mov [ebx], eax; *yp = temp;

   pop ebx
   pop eax

   add esp, 4
   pop ebp
   ret 8
swap ENDP
;==================================================================
;==================================================================
bubbleSort PROC
   push ebp
   mov ebp, esp
   sub esp, 8

   push eax
   push ebx
   push ecx
   push edx
   push esi
   push edi

   xor ecx, ecx
   mov [ebp-4], ecx; i = 0
   jmp first_for_jmp
;-------------------------------------------------------------------------   
first_loop:
   mov ecx, [ebp-4]
   inc ecx
   mov [ebp-4], ecx; i++
first_for_jmp:
   cmp ecx, [ebp+12];i < n
   jge out_side_first_loop;for (i = 0; i < n; i++)
   ;----------------------------------------------------------------------
   xor esi, esi
   mov [ebp-8], esi; j = 0
   dec ecx
   mov edi, [ebp+12]
   sub edi, ecx; n-i-1
   
   xor ecx, ecx; temp = j
   jmp second_jmp_for
second_loop:
   mov ecx, [ebp-8]
   inc ecx
   mov [ebp-8], ecx ;j
second_jmp_for:
   cmp ecx, edi
   jge exit_second_loop
   ;-----------------------------------------------------------------
   mov eax, [ebp+8]; arr
   mov ebx, [eax+ecx*4]
   mov edx, [eax+ecx*4+4]
   cmp ebx, edx; if (arr[j] > arr[j+1])
   jl dont_swap

   ;swap (&arr[j], &arr[j+1])
   lea edx, [eax+ecx*4+4]
   push edx
   lea ebx, [eax+ecx*4]
   push ebx
   call swap
dont_swap:
   ;-----------------------------------------------------------------
  jmp second_loop
   ;----------------------------------------------------------------------
exit_second_loop:
   jmp first_loop 
;-------------------------------------------------------------------------
out_side_first_loop:

   pop edi
   pop esi
   pop edx
   pop ecx
   pop ebx
   pop eax

   add esp, 8
   pop ebp
   ret 8
bubbleSort ENDP

;==================================================================
;==================================================================
main PROC
   push ebp
   mov ebp, esp
   sub esp, 32 ;Allocate memory

   push 11
   push offset array
   call bubbleSort
   mov eax, eax;In eax is the returned index
   add esp, 32
   pop ebp
   ret
main ENDP
END main
