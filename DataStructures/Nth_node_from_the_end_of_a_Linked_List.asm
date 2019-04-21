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

printNthFromLast PROC
   push ebp
   mov ebp, esp
   sub esp, 12

   push eax
   push ebx
   push ecx
   push edi
   push esi

   xor ecx, ecx
   mov eax, [ebp+8]
   mov [ebp-4], eax;  struct node *temp = head
   mov [ebp-8], ecx;  len = 0
   mov [ebp-12], ecx; i = 0

while_loop:
   cmp eax, NULL     ; while (temp != NULL)
   je exit_loop
   mov ebx, [eax+4]
   mov [ebp-4], ebx
   mov eax, [ebp-4] ; temp = temp->next 

   mov ecx, [ebp-8]
   inc ecx
   mov [ebp-8], ecx; len++
   jmp while_loop
exit_loop:
   cmp ecx, [ebp+12]; if (len < n)
   jl quit          ; return

   mov ebx, [ebp+8]
   mov [ebp-4], ebx; temp = head

   sub ecx, [ebp+12]
   add ecx, 1
   mov esi, ecx; len-n+1

   mov ecx, 1; i = 1

   jmp condition
for_loop: 
   inc ecx 
condition:
   cmp ecx, esi ; ESI = ;len-n+1  
   jge outside

   mov ebx, [ebp-4]
   mov ebx, [ebx+4]
   mov [ebp-4], ebx ; temp = temp->next
   jmp for_loop
outside:
   mov ebx, [ebp-4]
   mov eax, [ebx]  ; temp->data 

  .data
  szFmt db '%d ', 0
  .code
  invoke crt_printf, OFFSET szFmt, eax ; printf("%d ", temp->data); 
quit:
   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax

   add esp, 12
   pop ebp
   ret 8
printNthFromLast ENDP

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

   ;mov eax, [ebp-4]
   ;push eax
   ;call printList

   push 5
   mov eax, [ebp-4]
   push eax
   call printNthFromLast

   mov eax, [ebp-4]
   push eax
   call printList

   add esp, 32
   pop ebp
   ret
main ENDP
END main
