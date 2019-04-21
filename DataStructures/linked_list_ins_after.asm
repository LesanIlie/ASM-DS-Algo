.386
.MODEL flat, stdcall
.STACK 4096

include msvcrt.inc
includelib msvcrt.lib

.data
ListNode STRUCT 
    NodeData DWORD ?
    NextPtr  DWORD ?
ListNode ENDS

TotalNodeCount = 15
NULL = 0
Counter = 0

.data
ListNode<0,0>

.code

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
    mov [eax], ebx ;new_node->data = new_data
    
    mov ebx, [ebp+8]
    mov ebx, [ebx+4] 
    mov [eax+4], ebx; new_node->next = prev_node->next

    mov ebx, [ebp+8]
    mov [ebx+4], eax ; prev_node->next = new_node 


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

    mov esi, [ebp+8] ; head_ref
    mov edi, [ebp+12];new_data
    push 8
    call crt_malloc
    add esp, 4

    mov [eax], edi ;new_node->data = new_data;
    mov ebx, [esi] ;*head_ref
    mov [eax+4], ebx;new_node->next = *head_ref
    mov [esi], eax ;*head_ref = new_node

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
    pushad
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
    popad
    pop ebp
    ret 4

printList ENDP

main PROC
    push ebp
    mov ebp, esp
    sub esp, 32
  
    xor eax, eax
    mov [ebp-4], eax
    lea esi, [ebp-4]

    push 1
    push esi
    call push_element

    push 2
    push esi
    call push_element

    push 3
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