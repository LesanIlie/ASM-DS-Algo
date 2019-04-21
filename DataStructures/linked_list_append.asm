.386
.MODEL flat, stdcall
.STACK 4096

include msvcrt.inc
includelib msvcrt.lib

.data
ListNode STRUCT 
    NodeData DWORD ?
    NextPtr DWORD ?
ListNode ENDS

TotalNodeCount = 15
NULL = 0
Counter = 0

.data
ListNode<0,0>

.code
append PROC
    push ebp
    mov ebp, esp
    sub esp, 4
    push eax
    push ebx
    push ecx
    push edi
    
    xor eax, eax
    xor edi, edi
    mov [ebp-4], eax
    
    push 8
    invoke crt_malloc
    add esp, 4
    mov ecx, [ebp+12]
    mov [eax], ecx ;new_node->data = data
    
    mov [eax+4], edi
    
    xor ecx, ecx

    mov edi, [ebp+8] 
    cmp [edi], ecx; if (*head_ref == NULL)
    jne head_not_null; 
    mov [edi], eax; *head_ref = new_node;
    jmp exit 

    mov ecx, [ebp+8]; *last = *head_ref
    xor ebx, ebx

head_not_null:
    mov edi, [edi]
loop_again:
    cmp [edi+4], ebx
    je out_side
    mov edi, [edi+4]
    jmp loop_again  ; not realy a good name
out_side:
    mov [edi+4], eax
    jmp exit

exit:
    add esp, 4
    pop edi
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret 8
append ENDP

insert_after PROC
    push ebp
    mov ebp, esp

    push eax
    push ebx

    xor eax, eax
    cmp [ebp+8], eax
    je prev_node_null
    push 8
    call crt_malloc
    add esp, 4

    mov ebx, [ebp+12]
    mov [eax], ebx

    mov ebx, [ebp+8]
    mov ebx, [ebx+4]
    mov [eax+4], ebx

    mov ebx, [ebp+8]
    mov [ebx+4], eax
    prev_node_null:
    
    pop ebx
    pop eax
    pop ebp
    ret 8

insert_after ENDP

push_element PROC
     push ebp
     mov ebp, esp
     push eax
     push ebx
     push esi
     push edi

     mov esi, [ebp+8]
     mov edi, [ebp+12]
     push 8
     call  crt_malloc
     add esp, 4

     mov [eax], edi
     mov ebx, [esi]
     mov [eax+4], ebx
     mov [esi], eax

     pop edi
     pop esi
     pop ebx
     pop eax
     pop ebp
     ret 8
push_element ENDP


printList PROC

     push ebp
     mov ebp, esp
     
     push ebx
     push eax 
     push esi

     mov esi, [ebp+8]
     .data
     szFmtLoc db '%d ', 0
     .code

     while_loop:
     mov ebx, [esi+4]
     cmp ebx, NULL
     je quit_prg
     mov eax, [esi]
     invoke crt_printf, OFFSET szFmtLoc, eax
     mov esi, [esi+4]
     jmp while_loop
quit_prg:
    mov eax, [esi]
    invoke crt_printf, OFFSET szFmtLoc, eax
    pop esi
    pop eax
    pop ebx
    pop ebp
    ret 4
printList ENDP

main PROC
    push ebp
    mov ebp, esp
    ;Allocate memory
    sub esp, 32

    xor eax, eax
    mov [ebp-4], eax
    lea esi, [ebp-4]

    push 2
    push esi
    call append

    push 1
    push esi
    call push_element

    push 2
    push esi
    call push_element

    push 3
    push esi
    call push_element

    push 76
    push esi
    call append

    push 8
    push esi
    call push_element

    mov eax, [esi]
    mov eax, [eax+4]

    push 8
    push eax
    call insert_after

    mov eax, [ebp-4]
    push eax
    call printList

    add esp, 32
    pop ebp
    ret
main ENDP
END main