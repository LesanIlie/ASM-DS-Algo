.386
.MODEL flat, stdcall
.STACK 8096

include msvcrt.inc
includelib msvcrt.lib

.data

node STRUCT
     data DWORD ?
     next     DWORD ?
node ENDS

array BYTE 65h, 65h, 45h, 55h, 55h, 55h, 33h, 33h, 33h, 63h, 63h, 00h
L     DWORD 00h,00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h  ;100 elements and initialize all with zero
R     DWORD 00h,00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

node<0, 0>

.code
;==================================================================
pushNode PROC
   push ebp
   mov ebp, esp
   sub esp, 4

   push eax
   push ebx
   push ecx
   push edx

   push 8
   call crt_malloc
   add esp, 4
   mov [ebp-4], eax 
   
   mov edx, [ebp+12] ; new_data
   mov esi, [ebp+8]  ; *head_ref
   mov ebx, [esi]

   mov [eax], edx ;new_node->data = new_data;
   mov [eax+4], ebx ;new_node->next = (*head_ref);

   mov eax, [ebp-4]
   mov ecx, [ebp+8]
   mov [ecx], eax

   pop edx
   pop ecx
   pop ebx
   pop eax

   add esp, 4
   pop ebp
   ret 8
pushNode ENDP
;==================================================================

printArray PROC
    push ebp
    mov ebp, esp
    push ebx
    push eax
    push esi
    ;mov esi, [ebp+8]
    .data
   szFmtLoc db '%d ', 0
   szFmtNewLine db '\n', 0
   .code

    xor ebx, ebx
    mov esi, [ebp+8]
    while_loop: 
    cmp ebx, [ebp+12]
    jge quit_prg
    mov eax, [esi]
    invoke crt_printf, OFFSET szFmtLoc, eax
    mov esi, [esi+4]
    inc ebx
    jmp while_loop
    quit_prg:
    .data
    szFmtNew db 10, 0; 10 is NEW LINE, aka: '\n' 
    .code
    mov eax, 0
    invoke crt_printf, OFFSET szFmtNew, eax
    pop esi
    pop eax
    pop ebx
    pop ebp
    ret 8
printArray ENDP

;==================================================================
count PROC
push ebp
   mov ebp, esp
   sub esp, 8
   push eax
   push ebx
   push ecx
   push edx

   mov eax, [ebp+8]; *current = head
   mov [ebp-4], eax

   xor ecx, ecx
   mov [ebp-8], ecx

@while_loop:
  xor ecx, ecx
  cmp [ebp-4], ecx
  je @exit_while
  mov eax, [ebp-4]
  mov edx, [eax]; current->data
  cmp edx, [ebp+12]
  jne @not_equal
  
  mov eax, [ebp-8]
  inc eax
  mov [ebp-8], eax; count++
@not_equal:  
  mov eax, [ebp-4]
  mov edx, [eax+4]
  mov [ebp-4], edx; current = current->next
  jmp @while_loop

@exit_while:
   pop edx
   pop ecx
   pop ebx
   pop eax
   mov eax, [ebp-8] ; return count
   pop ebp
   add esp, 8
   ret 8
count ENDP	
;==================================================================
main PROC
   push ebp
   mov ebp, esp
   sub esp, 100 ;Allocate memory
   xor eax, eax
   mov [ebp-4], eax
   mov [ebp-8], eax

   push 1
   lea eax, [ebp-8]
   push eax
   call pushNode

   push 12
   lea eax, [ebp-8]
   push eax
   call pushNode

   push 1
   lea eax, [ebp-8]
   push eax
   call pushNode

   push 2
   lea eax, [ebp-8]
   push eax
   call pushNode

   push 11
   lea eax, [ebp-8]
   push eax
   call pushNode

   push 5	
   mov eax, [ebp-8]
   push eax
   call printArray
   
   push 1
   mov eax, [ebp-8]
   push eax;EAX CONTAINS THE RESULT
   call count

   add esp, 100
   pop ebp
   ret
main ENDP
END main
