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

 GetNthNode PROC
     push ebp
     mov ebp, esp
     sub esp, 8

     push ecx
     push ebx
     push edi

     xor eax, eax
     mov [ebp-4], eax;count = 0;

     mov edi, [ebp+8]
     mov [ebp-8], edi ;struct node *current  = head;
     mov eax, edi; EAX = current

    while_loop:
    cmp eax, NULL
    je quit_prg
    mov ebx, [ebp-4]; counter
    cmp ebx, [ebp+12] ;if (count == index)
    je equal_coutnter           ;return(current->data)
    inc ebx
    mov [ebp-4], ebx;counter++

    mov edi, [ebp-8]
    mov eax, [edi+4]
    mov [ebp-8], eax; current = curent->next;  
    jmp while_loop

    equal_coutnter:
    mov eax, [ebp-8] ;return(current->data)
    mov eax, [eax]
    quit_prg:
    pop edi
    pop ebx
    pop ecx

    add esp, 8
    pop ebp
    ret 8
GetNthNode ENDP

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
   push 3
   push eax
   call GetNthNode

   add esp, 32
   pop ebp
   ret
main ENDP
END main
