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
push_element PROC
    push ebp
    mov ebp, esp
    sub esp, 8

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    push 8
    call crt_malloc
    add esp, 4

    mov [ebp-4], eax ; struct node *ptr1 = (struct node *)malloc(sizeof(struct node));
   
    mov eax, [ebp+8]
    mov eax, [eax]
    mov [ebp-8], eax; struct node *temp = *head_ref;

    mov ebx, [ebp-4]
    mov ecx, [ebp+12]; data
    mov [ebx], ecx   ; ptr1->data = data;
    mov [ebx+4], eax ; ptr1->next = *head_ref;

    cmp eax, 0
    je @is_NULL_else
@while_loop:
    mov eax, [ebp-8];temp
    mov ebx, [ebp+8]
    mov ebx, [ebx]; *head_ref
    cmp [eax+4], ebx
    je @equal_head
    mov ebx, [eax+4]
    mov [ebp-8], ebx ;temp = temp->next;
    jmp @while_loop
@equal_head:
    mov ebx, [ebp-8];temp
    mov ecx, [ebp-4];ptr1
    mov[ebx+4], ecx ;temp->next = ptr1;
    jmp @out_side_if
@is_NULL_else:
    mov eax, [ebp-4]
    mov [eax+4], eax ; ptr1->next = ptr1;
@out_side_if:
    mov ebx, [ebp+8] ; head_ref
    mov eax, [ebp-4] ; ptr1
    mov [ebx], eax   ; *head_ref = ptr1;

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    add esp, 8
    pop ebp
    ret 8
push_element ENDP

;==================================================================
printArray PROC
    push ebp
    mov ebp, esp
    pushad
    push ebx
    push eax
    push esi
    ;mov esi, [ebp+8]
    .data
   szFmtLoc db '%d ', 0
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
   sub esp, 100 ;Allocate memory
   xor eax, eax
   mov [ebp-4], eax
   mov [ebp-8], eax
   push 11
   lea eax, [ebp-8]
   push eax
   call push_element

   push 12
   lea eax, [ebp-8]
   push eax
   call push_element

   push 56
   lea eax, [ebp-8]
   push eax
   call push_element

   push 2
   lea eax, [ebp-8]
   push eax
   call push_element

   push 11
   lea eax, [ebp-8]
   push eax
   call push_element

   mov eax, [ebp-8]
   push 4
   push eax
   call printArray
   
   add esp, 100
   pop ebp
   ret
main ENDP
END main
