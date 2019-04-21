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

selectionSort PROC
   push ebp
   mov ebp, esp
   sub esp, 12
   push eax
   push ebx
   push ecx
   push esi
   push edi

   xor ecx, ecx
   mov [ebp-4], ecx    ; i = 0 
   mov esi, [ebp+12]
   dec esi             ; n-1
jmp first_for_jmp

for_loop:
   mov ecx, [ebp-4]
   inc ecx
   mov [ebp-4], ecx   ; i++
first_for_jmp:
   cmp ecx, esi       ; i < n-1 
   jge outsideloop 
   mov [ebp-8], ecx   ; min_idx = i
   ;==============================

   mov ebx, ecx
   inc ebx
   mov [ebp-12], ebx  ; j = i+1
   jmp second_jmp

 second_for:;<-----------------------------
   mov ebx, [ebp-12]
   inc ebx
   mov [ebp-12], ebx ; j++;
 second_jmp:
   cmp ebx, [ebp+12] ; j < n
   jge out_side_second_loop

   mov eax, [ebp+8]  ;arr
   mov edi, [ebp+8]  ;arr  

   mov eax, [eax+ebx*4];arr[j]
   mov ecx, [ebp-8]  ; min_idx
   mov edi, [edi+ecx*4];arr[min_idx]
   cmp eax, edi
   jge grather
   mov [ebp-8], ebx ;min_idx = j
grather:
   jmp second_for;<-------------------------
   ;==============================
out_side_second_loop:
   mov eax, [ebp+8]
   mov edi, [ebp-4]; i not j!!!
  
   lea eax, [eax+edi*4];arr[j]
   push eax
   mov eax, [ebp+8];arr
   mov ecx, [ebp-8];min_idx
   lea eax, [eax+ecx*4];arr[min_idx]
   push eax
   call swap
   
jmp for_loop
outsideloop:

   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax

   add esp, 12
   pop ebp
   ret 12
selectionSort ENDP

;==================================================================
;==================================================================
main PROC
   push ebp
   mov ebp, esp
   sub esp, 32 ;Allocate memory

   push 11
   push offset array
   call selectionSort
   mov eax, eax;In eax is the returned index
   add esp, 32
   pop ebp
   ret
main ENDP
END main
