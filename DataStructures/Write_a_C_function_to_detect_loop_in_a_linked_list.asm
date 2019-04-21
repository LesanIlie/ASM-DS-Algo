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
detectLoop PROC
    push ebp
    mov ebp, esp
    sub esp, 8

    push eax
    push ebx
    push ecx

    mov eax, [ebp+8]
    mov [ebp-4], eax ; struct node *slow_p = list, 
    mov [ebp-8], eax; *fast_p = list

while_loop:
    cmp eax, NULL
    je out_side_while;slow_ptr
    mov ecx, [ebp-8]
    cmp ecx, NULL
    je out_side_while;fast_ptr
    mov ebx, [ecx+4]
    cmp  ebx, NULL
    je out_side_while;fast_ptr->next

    mov eax, [eax+4]
    mov [ebp-4], eax ; slow_p = slow->next

    mov ecx, [ebx+4];
    mov [ebp-8], ecx; fast_p= fastp->next->next

    cmp eax, ecx
    je found

    jmp while_loop
out_side_while:
.data
    fmt db '%s ', 0 
    str_found db 'Loop found ', 0
    str_not_found db 'Loop NOT found ', 0
.code

not_found:
   xor esi, esi
   invoke crt_printf, OFFSET fmt, OFFSET str_not_found
   jmp quit
found:
   invoke crt_printf, OFFSET fmt, OFFSET str_found 
   mov esi, 1
quit:
    pop ecx
    pop ebx
    pop eax

    add esp, 8
    pop ebp
    ret 4
detectLoop ENDP
;==================================================================
;==================================================================
main PROC
   push ebp
   mov ebp, esp
   sub esp, 32 ;Allocate memory

   xor eax, eax
   mov [ebp-4], eax
   lea esi, [ebp-4]

   push 20
   push esi
   call push_element
   
   push 4
   push esi
   call push_element 
   
   push 15
   push esi
   call push_element
   
   push 10
   push esi
   call push_element
   push 11
   push esi
   call push_element

   mov ecx, [ebp-4];head

   mov eax,[ecx+4]; head->next
   mov eax, [eax+4]; head->next->next
   mov eax, [eax+4]; head->next->next->next;
   mov [eax+4], ecx; head->next->next->next = head;
   
   ;mov [eax+4], ecx; head->next->next->next = head;


   mov eax, [ebp-4]
   push eax
   call detectLoop
   ;ESI is zero = Loop Found

   add esp, 32
   pop ebp
   ret
main ENDP
END main
