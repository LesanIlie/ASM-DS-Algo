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

deleteFirst PROC
   push ebp
   mov ebp, esp
   sub esp, 4

   push eax
   push ebx
   push edi
   push ecx

   xor ecx, ecx
   mov eax, [ebp+8]

   cmp [eax], ecx; *head_ref
   je quit;         if (*head_ref != NULL)
   mov ebx, [eax];  *temp = *head_ref
   
   mov edi, [eax]
   mov edi, [edi+4]
   mov [eax], edi ; *head_ref = (*head_ref)->next

   push ebx
   call crt_free
   add esp, 4; free(temp);

quit:
   pop ecx
   pop edi
   pop ebx
   pop eax
   
   add esp, 4
   pop ebp
   ret 4
deleteFirst ENDP

;==================================================================
;==================================================================
deleteList PROC
     push ebp
     mov ebp, esp
     sub esp, 8

     push esi
     push eax
     push ebx
     push edi

     mov esi, [ebp+8]; head_ref
     mov edi, [ebp+12]; key

     mov ebx, [esi]   
     mov [ebp-4], ebx; ptemp = *head_ref

;==================================================================
    cmp ebx, NULL; EBX <= ptemp
    je while_branch ;if (temp != NULL && temp->data == key)

    cmp[ebx], edi; EDI <= key
    jne while_branch ;if (temp != NULL && temp->data == key)

    mov eax, [ebx+4]; *head_ref = temp->next
    mov [esi], eax

    push ebx
    call crt_free
    add esp, 4;check if realy i need to clean the stac, microsoft vs c caling convention
jmp quit;exit
;==================================================================
while_branch:
   cmp ebx, NULL
   je outside
   cmp [ebx], edi
   je outside

   mov eax, ebx
   mov ebx, [ebx+4]
   jmp while_branch
;==================================================================

outside:
;if (temo == NULL)
;    return;
;prev->next = temp->next
   cmp ebx, NULL
   je quit

   mov edi, [ebx+4]; temp->next
   mov [eax+4], edi

   push ebx
   call crt_free
   add esp, 4
;==================================================================
quit:
     pop edi
     pop ebx
     pop eax
     pop esi

     add esp, 8
     pop ebp
     ret 8
deleteList ENDP
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

   mov eax, [ebp-4]
   push eax
   call printList

   ;push 3
   ;push esi
   ;call deleteList

   ;mov eax, [ebp-4]
   ;push eax
   ;call printList

   push esi
   call deleteFirst

   mov eax, [ebp-4]
   push eax
   call printList

   add esp, 32
   ret
main ENDP
END main
;==================================================================
;==================================================================