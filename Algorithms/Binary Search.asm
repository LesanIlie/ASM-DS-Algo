.386
.MODEL flat, stdcall
.STACK 4096

include msvcrt.inc
includelib msvcrt.lib

.data

array DWORD 10h, 11h, 12h, 13h

.code
binarySearch PROC
    push ebp
    mov ebp, esp
    sub esp, 4

    push ebx
    push ecx
    push esi
    push edi
    
 while_loop:
    mov ecx, [ebp+12]; l
    cmp ecx, [ebp+16]; l <= r
    jge out_side

    mov eax, [ebp+16]
    sub eax, ecx; (r-l)
    cdq
    sub eax, edx
    sar eax, 1
    add eax, ecx

    mov [ebp-4], eax; m = l + (r-l)/2

    mov ebx, [ebp+20]; x
    mov esi, [ebp+8];  arr[]

    mov edi, [esi+eax*4];temp
    lea edi, [esi+eax*4];temp    
    cmp [esi+eax*4], ebx ; return m
    je found             ; return m

    cmp [esi+eax*4], ebx
    jge right
    inc eax
    mov [ebp+12], eax;l = m + 1;
    jmp check_made
right:
   dec eax
   mov [ebp+16], eax; r = m - 1;
check_made:                   
    jmp while_loop        
out_side:
   mov eax, -1
   jmp quit
found: 
   mov eax, eax
   jmp quit
not_found:
   xor eax, eax
 quit:
    pop edi
    pop esi
    pop ecx
    pop ebx
    
    add esp, 4
    pop ebp
    ret 16
binarySearch ENDP

;==================================================================
;==================================================================
main PROC
   push ebp
   mov ebp, esp
   sub esp, 32 ;Allocate memory


   push 12h
   push 4
   push 0
   push offset array
   call binarySearch
   mov eax, eax;In eax is the returned index
   add esp, 32
   pop ebp
   ret
main ENDP
END main
