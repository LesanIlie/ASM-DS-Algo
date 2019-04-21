.386 
.MODEL flat, stdcall
.STACK 4096

include msvcrt.inc
includelib msvcrt.lib

.data 

.code

Rotate PROC
   push ebp
   mov ebp, esp
   sub esp, 12

   push eax
   push ebx
   push ecx
   push esi
   push edi

   mov eax, [ebp+12] ; k
   cmp eax, 0        ; if(k == 0)
   je @exit          ;   return;

   mov eax, [ebp+8] ; head_ref
   mov eax, [eax]   ; *head_ref
   mov [ebp-8], eax ; struct node* current = *head_ref 
   
   mov ecx, 1
   mov [ebp-4], ecx ; count = 1
   
@get_k_node_loop:
   mov ecx, [ebp-4]  ; count
   mov ebx, [ebp+12] ; k 
   cmp ecx, ebx 
   jge @exit_get_k_node
   mov eax, [ebp-8]  ; current
   cmp eax, 0
   je  @exit_get_k_node

   mov edx, [eax+4] ; current->next
   mov [ebp-8], edx ; current = current->next;
   
   inc ecx
   mov [ebp-4], ecx ; count++
   jmp @get_k_node_loop
@exit_get_k_node: 
  
  mov eax, [ebp-8]; if (current == NULL)
  cmp eax, 0      ;     return; 
  je @exit        ;

  mov [ebp-12], eax ; struct node *kthNode = current;

@get_last_node:
  mov eax, [ebp-8] ; current
  mov eax, [eax+4] ; current->next
  cmp eax, 0
  je @exit_get_last_node
  mov [ebp-8], eax ; current = current->next
  jmp @get_last_node
@exit_get_last_node:
 
 mov eax, [ebp-8] ; current
 mov ebx, [ebp+8] ; head_ref
 mov ecx, [ebx]   ; *head_ref
 mov [eax+4], ecx ; current->next = *head_ref

 mov edi, [ebp-12] ; kthNode
 mov esi, [edi+4]  ; kthNode->next

 mov [ebx], esi ; *head_ref = kthNode->next

 xor ecx, ecx
 mov [edi+4], ecx ; kthNode->next = NULL

@exit:
   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax

   add esp, 12
   pop ebp
   ret 8
Rotate ENDP

PushNode PROC
   push ebp
   mov ebp, esp
   sub esp, 4   ; One local variable

   push eax
   push ebx
   push ecx
   push esi
   push edi

   push 8          ; sizeof(struct node)
   call crt_malloc
   add esp, 4

   ;TODO: Check for NULL pointer
   mov [ebp-4], eax ; NewNode = malloc(sizeof(struct node))

   mov ecx, [ebp+12] ; Second parameter from stack(data)
   mov [eax], ecx ; NewNode->data = data; (accesing 4 bytes)
  
   mov ecx, [ebp+8] ; First parameter from stack(head_ref**)
   mov ebx, [ecx] ; Get the head, ex: (*head_ref) 
   
   mov [eax+4], ebx ; NewNode->Next = (*head_ref)
   
   mov [ecx], eax ; (*head_ref) = NewNode; we have a new head

   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax

   add esp, 4
   pop ebp
   ret 8

PushNode ENDP

PrintArray PROC
    push ebp 
	mov ebp, esp

	push ebx
	push eax
	push esi
.data
   szFmtLoc db '%d ',0
.code
    xor ebx, ebx
	mov esi, [ebp+8] ; Head of the linked list
@while_loop:
    cmp ebx, [ebp+12] ; size of the linked list
	jge @finish
	mov eax, [esi] ; data = node->data(first 4 bytes of memory)
	invoke crt_printf, OFFSET szFmtLoc, eax
	mov esi, [esi+4]
	inc ebx
	jmp @while_loop
.data
    szFmtNew db 10, 0; 0 is new line, aka: '\n'
.code
   mov eax, 0
   invoke crt_printf, OFFSET szFmtNew, eax

@finish:
	pop esi
	pop eax
	pop ebx

	pop ebp
	ret 8
PrintArray ENDP

main PROC
    push ebp
	mov ebp, esp
	sub esp, 4; Allocate 4 bytes

	push eax
	
	xor eax, eax
	mov[ebp-4], eax

	push 10
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 20
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 30
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 40
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 50
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 60
	lea eax, [ebp-4]
	push eax
	call PushNode

	mov eax, [ebp-4]
	
	push 6 ; 6 elemnts
	push eax;  push the head
	call PrintArray

	push 4
	lea eax, [ebp-4]
	push eax
	call Rotate

	mov eax, [ebp-4]
	
	push 6 ; 6 elemnts
	push eax;  push the head
	call PrintArray

	pop eax

	add esp, 4
	pop ebp
	ret
main ENDP
END main