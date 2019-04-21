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
count PROC
   push ebp
   mov ebp, esp
   sub esp, 8
    
   push ebx
   push ecx
   push edx

   mov eax, [ebp+8]
   mov [ebp-4], eax; struct node *current = head

   xor ecx, ecx
   mov [ebp-8], ecx

while_loop:
   cmp eax, NULL; while (current != NULL)
   je out_side;   {
   
   mov ecx, [eax];current->data
   cmp ecx, [ebp+12]; if (current->data == search_for)
   jne not_equal
   mov ecx, [ebp-8]
   inc ecx
   mov [ebp-8], ecx;count++;
not_equal:
   mov eax, [eax+4]; current = current->next
   jmp while_loop
out_side:

   mov eax, [ebp-8];return count;
   pop edx
   pop ecx
   pop ebx

   add esp, 8
   pop ebp
   ret 8
count ENDP

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
   push 1
   push esi
   call push_element
   push 5
   push esi
   call push_element
   push 6
   push esi
   call push_element
   push 1
   push esi
   call push_element
   push 8
   push esi
   call push_element
   push 1
   push esi
   call push_element

   push 1
   mov eax, [ebp-4]
   push eax
   call count
  
   add esp, 32
   pop ebp
   ret
main ENDP
END main
