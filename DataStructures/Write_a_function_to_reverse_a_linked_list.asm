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
reverse PROC
    push ebp
    mov ebp, esp
    sub esp, 12

    push eax
    push ebx
    push ecx
    push esi
    push edi

    xor ecx, ecx

    mov [ebp-4], ecx; struct node *prev = NULL
    
    mov eax, [ebp+8]
    mov eax, [eax]
    mov [ebp-8], eax; struct node *current = *head_ref

while_loop:
   cmp eax, NULL      ; while(current != NULL)
   je out_side        ;{
   mov ecx, [eax+4]
   mov [ebp-12], ecx  ;next = current->nex
   
   mov ecx, [ebp-4]  ;prev
   mov [eax+4], ecx  ;current->next = prev 

   mov [ebp-4], eax; prev = current
   
   mov eax, [ebp-12]
   mov [ebp-8], eax; current = next

   jmp while_loop
out_side: 
   
   mov ecx, [ebp-4] ;prev
   mov eax, [ebp+8] ;header_ref
   mov [eax], ecx    ;*head_ref = prev 

   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax

   add esp, 12
   pop ebp
   ret 4
reverse ENDP
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
   push 2
   push esi
   call push_element 
   push 3
   push esi
   call push_element
   push 4
   push esi
   call push_element
   push 5
   push esi
   call push_element
   push 6
   push esi
   call push_element
   push 7
   push esi
   call push_element
   push 8
   push esi
   call push_element
   push 9
   push esi
   call push_element
   
  mov eax, [ebp-4]
  push eax 
  call printList

  push esi
  call reverse

  mov eax, [ebp-4]
  push eax 
  call printList

  add esp, 32
  pop ebp
  ret
main ENDP
END main
