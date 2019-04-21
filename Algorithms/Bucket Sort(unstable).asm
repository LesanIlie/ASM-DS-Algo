.386
.MODEL flat, stdcall
.STACK 8096

include msvcrt.inc
includelib msvcrt.lib

.data

array DWORD 13h, 11h, 7h, 9h, 6h, 1h, 3h, 5h, 11h, 13h, 12h, 00h
L     DWORD 00h,00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h  ;100 elements and initialize all with zero
R     DWORD 00h,00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

.code
;================================================================== 
  Bucket_Sort PROC
  push ebp
  mov ebp, esp
  sub esp, 64 ; n <= alloc space for count
  push eax
  push ebx
  push ecx
  push edx
  push esi
  push edi
;----------------------------------------------------------
  xor ecx, ecx
  mov [ebp-4], ecx; i = 0
  jmp @first_for_jmp
@first_loop:
  mov ecx, [ebp-4]
  inc ecx
  mov [ebp-4], ecx; i++
@first_for_jmp:
  cmp ecx, [ebp+12]
  jge @out_side_first_for
  mov esi, [ebp+12]
  dec esi; in tab n-1 elemente
  imul esi, 4
  lea eax, [ebp-12];count
  add eax, esi;4 bytes for each element
  xor edx, edx
  mov [eax+ecx*4], edx ; if ECX is too large, is posible to fuck the stack
  jmp @first_loop
@out_side_first_for:
;----------------------------------------------------------
  xor ecx, ecx
  mov [ebp-4], ecx; i = 0
  jmp @second_for_jmp
@second_loop:
  mov ecx, [ebp-4]
  inc ecx
  mov [ebp-4], ecx; i++
@second_for_jmp:
  cmp ecx, [ebp+12]
  jge @out_side_second_for
  lea eax, [ebp-12]
  mov esi, [ebp+12]
  dec esi
  imul esi, 4
  add eax, esi    ; count + n; because we are on stack
  mov edx, [ebp+8]     ; array
  mov esi, [edx+ecx*4] ; array[i]
  mov ebx, [eax+esi*4] ; (count[array[i]])
  inc ebx
  mov [eax+esi*4], ebx ; (count[array[i]])++;
  jmp @second_loop
 @out_side_second_for:
;----------------------------------------------------------
  xor ecx, ecx
  mov [ebp-4], ecx; i = 0
  mov [ebp-8], ecx; j = 0
  jmp @jmp_third_for
@third_loop:
  mov ecx, [ebp-4]
  inc ecx
  mov [ebp-4], ecx; i++
@jmp_third_for:
 cmp ecx, [ebp+12]
 jge @out_side_third_for
   ;----------------------------------------------------------
 lea eax, [ebp-12]
 mov esi, [ebp+12]
 dec esi
 imul esi, 4
 add eax, esi; for how the stack is organized
 mov ebx, [eax+ecx*4]; count[i]
 jmp @first_jmp_inner_loop
 @iner_loop:
 lea eax, [ebp-12]
 mov esi, [ebp+12]
 dec esi
 imul esi, 4
 add eax, esi; for how the stack is organized
 mov ebx, [eax+ecx*4]; count[i]
 dec ebx  
 mov [eax+ecx*4], ebx ;count[i]--
 @first_jmp_inner_loop:
 cmp ebx, 0
 jle @out_side_inner
 mov esi, [ebp+8];array
 mov edi, [ebp-8];j
 mov [esi+edi*4], ecx ;array[j++] = i;
 mov ecx, [ebp-8]
 inc ecx
 mov [ebp-8], ecx; j++
 jmp @iner_loop
 @out_side_inner:
   ;----------------------------------------------------------
 jmp @third_loop
 @out_side_third_for:
;----------------------------------------------------------
  pop edi
  pop esi
  pop edx
  pop ecx
  pop ebx
  pop eax
  add esp, 64
  pop ebp
  ret 8
  Bucket_Sort ENDP

;==================================================================
printArray PROC
    push ebp
    mov ebp, esp
    pushad
    push ebx
    push eax
    push esi
    mov esi, [ebp+8]
    .data
   szFmtLoc db '%d ', 0
   .code

    xor ebx, ebx
    while_loop: 
    cmp ebx, [ebp+12]
    jge quit_prg
    mov eax, [esi]
    invoke crt_printf, OFFSET szFmtLoc, eax
    add esi, 4
    inc ebx
    jmp while_loop
    quit_prg:
    .data
    szFmt db '%d ', 10 , 0; 10 is NEW LINE, aka: '\n' 
    .code
    mov eax, [esi]
    invoke crt_printf, OFFSET szFmt, eax
    pop esi
    pop eax
    pop ebx
    popad
    pop ebp
    ret 8
printArray ENDP

;==================================================================
main PROC
   push ebp
   mov ebp, esp
   sub esp, 34 ;Allocate memory

   push 11
   push offset array
   call printArray

   push 13h
   push offset array
   call Bucket_Sort
   
   push 11
   push offset array
   call printArray

   add esp, 34
   pop ebp
   ret
main ENDP
END main
