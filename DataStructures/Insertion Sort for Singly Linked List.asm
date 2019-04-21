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
sortedInsert PROC
   push ebp
   mov ebp, esp
   sub esp, 4
   push eax
   push ebx
   push ecx
   push esi
   push edi

   mov eax, [ebp+8] ; head_ref
   mov ecx, [eax]   ; *head_ref, 4 bytes
   mov ebx, [ebp+12]; new_node 
   cmp ecx, 0

   je @if_statement
   mov edx, [ecx] ; (*head_ref)->data
   mov ebx, [ebp+12]; new_node 
   mov edi, [ebx] ; new_node->data

   cmp edx, edi
   jl @else ; logica inversa
;_________________________________________________________
@if_statement:
   mov [ebx+4], ecx ; new_node->next = *head_ref
   mov [eax], ebx ; *head_ref = new_node
;_________________________________________________________
   jmp @exit   
@else:
;_________________________________________________________
; Add code
   mov [ebp-4], ecx; current = *head_ref
@while_loop:
   mov eax, [ebp-4]   ; current
   mov ebx, [eax+4]   ; current->next

   mov edi, [ebp+12]
   mov esi, [edi]    ; new_node->data

   cmp ebx, 0        ; while (current->next!=NULL &&
   je @exit_while    

   mov ecx, [eax+4]   ; current->next
   mov ecx, [ecx]     ; current->next->data

   cmp ecx, esi      ; current->next->data < new_node->data)
   jge @exit_while   ; {
   
   mov eax, [ebp-4]
   mov ecx, [eax+4]  ; current->next
   mov [ebp-4], ecx
   jmp @while_loop
   @exit_while:
   mov edi, [ebp+12] ; new_node
   mov ecx, [ebp-4] ;current
   mov esi, [ecx+4] ; current->next
   mov [edi+4], esi  ; new_node->next  = current->next

   mov [ecx+4], edi  ; current->next = new_node
   ;}
;_________________________________________________________
@exit:
   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax

   add esp, 4
   pop ebp
   ret 8
sortedInsert ENDP
;==================================================================
insertionSort PROC
   push ebp
   mov ebp, esp
   sub esp, 12
   push eax
   push ebx
   push ecx
   push esi
   push edi

   xor ecx, ecx
   mov [ebp-4], ecx   ; struct node *sorted = NULL;
   
   mov eax, [ebp+8]
   mov eax, [eax]
   mov [ebp-8], eax   ; struct node *current = *head_ref;

@while_loop:
  mov eax, [ebp-8]
  cmp eax, 0
  je @out_side        ; while(current != NULL)
                      ;{
  
  mov edx, [eax+4]
  mov [ebp-12], edx   ; struct node *next = current->next

  lea edi, [ebp-4]    ; sorted
  push eax            ; current
  push edi            ; &sorted
  call sortedInsert   ; sortedInserted(&sorted, current);
  
  mov ebx, [ebp-12]    ; current= next;
  mov [ebp-8], ebx
  
  jmp @while_loop     ;}
@out_side:
   
   mov eax, [ebp+8]   ; head_ref
   mov ebx, [ebp-4]   ; sorted
   mov [eax], ebx     ; *head_ref

   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax
   add esp, 12
   pop ebp
   ret 4
insertionSort ENDP
;==================================================================
newNode PROC
   push ebp
   mov ebp, esp
   sub esp, 4
   push eax
   push ebx
   push ecx
   push esi
   push edi

   push 8
   call crt_malloc ; struct node* new_node =
   add esp, 4
   mov [ebp-4], eax ;(struct node*) malloc(sizeof(struct node));

   mov ecx, [ebp+8]
   xor edx, edx
   mov [eax], ecx ; new_node->data  = new_data;
   mov [eax+4], edx ; new_node->next =  NULL;

   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax
   mov eax, [ebp-4] ;return new_node;
   add esp, 4
   pop ebp
   ret 4
newNode ENDP

;==================================================================

pushNode PROC
   push ebp
   mov ebp, esp
   sub esp, 4
   push eax
   push ebx
   push ecx
   push esi
   push edi

   push 8
   call crt_malloc 
   add esp, 4
   
   mov [ebp-4], eax

   mov ecx, [ebp+12]

   mov [eax], ecx ;new_node->data  = new_data;

   mov edi, [ebp+8]
   mov esi, [edi]
   mov [eax+4], esi;new_node->next = (*head_ref);
   
   mov edx, [ebp-4]
   mov [edi], edx ;(*head_ref)    = new_node;

   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax
   add esp, 4
   pop ebp
   ret 8
pushNode ENDP

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
   szFmtNewLine db '\n', 0
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
    .data
    szFmtNew db 10, 0; 10 is NEW LINE, aka: '\n' 
    .code
    mov eax, 0
    invoke crt_printf, OFFSET szFmtNew, eax
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
   call pushNode

   push 12
   lea eax, [ebp-8]
   push eax
   call pushNode

   push 56
   lea eax, [ebp-8]
   push eax
   call pushNode

   push 2
   lea eax, [ebp-8]
   push eax
   call pushNode

   push 11
   lea eax, [ebp-8]
   push eax
   call pushNode

   mov eax, [ebp-8]
   push 5
   push eax
   call printArray
   
   lea eax, [ebp-8]
   push eax
   call insertionSort

   mov eax, [ebp-8]
   push 5
   push eax
   call printArray
   
   add esp, 100
   pop ebp
   ret
main ENDP
END main
