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

TotalNodeCount  = 15
NULL = 0
Counter = 0

.data
ListNode<0,0>
.code
;==================================================================
;==================================================================
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
    call crt_malloc
    add esp, 4

    mov [eax], edi; new_node->data= data;
    mov ebx, [esi]
    mov [eax+4], ebx;new_node->next = *head_ref;
    mov [esi], eax; *head_ref = new_node;
    
    pop edi
    pop esi
    pop ebx
    pop eax

    pop ebp
    ret 8
push_element ENDP
;==================================================================
;==================================================================
deleteNode PROC
   push ebp
   mov ebp,esp
   sub esp, 4
  
   push eax
   push ebx
   push ecx
   push ebx

   mov eax, [ebp+8]
   mov ecx, [eax+4]
   mov [ebp-4], ecx; struct node *temp = node_ptr->next

   mov ebx, [ecx]
   mov [eax], ebx; node_ptr->data = temp->data;

   mov ebx, [ecx+4]
   mov [eax+4], ebx; node_ptr->data = temp->next;
   
   pop ebx
   pop ecx
   pop ebx
   pop eax
   
   add esp, 4
   pop ebp
   ret 4
deleteNode ENDP

;==================================================================
;==================================================================
printList PROC
    push ebp
    mov ebp, esp
    ;save the register
    push ebx
    push eax
    push esi

    mov esi, [ebp+8]

    .data
    szFmtLoc db '%d ', 0
    .code
while_loop:
    mov ebx, [esi+4]
    cmp ebx, NULL   ;while (node->next != NULL) 
    je quit_prg     ;{
    mov eax, [esi]  ;printf("%d", node->data);
    invoke crt_printf, OFFSET szFmtLoc, eax
    mov esi, [esi+4];node = node->next;
    jmp while_loop  ;}
quit_prg:
    mov eax, [esi]
    invoke crt_printf, OFFSET szFmtLoc, eax
    ;restore the registers
    pop esi
    pop eax
    pop ebx

    pop ebp
    ret 4
printList ENDP
;==================================================================
;==================================================================

main PROC
   push ebp
   mov ebp, esp
   sub esp, 32 ;Allocate memory

   xor eax, eax
   mov [ebp-4], eax
   lea esi, [ebp-4]

   push 1
   push esi
   call push_element

   
   push 4
   push esi
   call push_element
   
   push 1
   push esi
   call push_element

   push 12
   push esi
   call push_element
   
   push 1
   push esi
   call push_element

    mov eax, [ebp-4]
   push eax
   call printList

   mov eax, [ebp-4]
   push eax
   call deleteNode

   mov eax, [ebp-4]
   push eax
   call printList

   add esp, 32
   pop ebp
   ret
main ENDP
END main
