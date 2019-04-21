.386
.MODEL flat, stdcall
include msvcrt.inc
includelib msvcrt.lib


.data
;Data here
.code
;==============================================================
newNode PROC
   push ebp
   mov ebp, esp
   sub esp, 4
   push eax
   push ecx

   push 8
   call crt_malloc 
   add esp, 4

   mov [ebp-4], eax ; struct node *temp = malloc(sizeof (struct node))

   mov ecx, [ebp+8]
   mov [eax], ecx ; temp->data = key;
   xor ecx, ecx
   mov [eax+4], ecx  ;temp->next = NULL;
   
   pop ecx
   pop eax
   mov eax, [ebp-4] ; return temp
   add esp, 4
   pop ebp
   ret 4
newNode ENDP
;==============================================================
reverseList PROC
   push ebp
   mov ebp, esp
   sub esp, 12
   
   push eax
   push ecx
   push ebx
   push edx

   mov eax, [ebp+8] ; head
   mov eax, [eax]   ; *head

   xor ecx, ecx
   mov [ebp-4], ecx ; struct node *prev = NULL;
   mov [ebp-8], eax ; struct node *curr = *head;

@loop_while_not_null:
   mov eax, [ebp-8]
   cmp eax, 0
   je @exit_while
   
   mov ecx, [eax+4]
   mov [ebp-12], ecx ; next = curr->next

   mov edx, [ebp-4] ; prev
   mov [eax+4], edx ; curr->next = prev
   
   mov [ebp-4], eax ; prev = curr;

   mov [ebp-8], ecx ; curr = prev

   jmp @loop_while_not_null
@exit_while:
   mov eax, [ebp+8]
   mov ecx, [ebp-4]
   mov [eax], ecx ; *head = prev

   pop edx
   pop ebx
   pop ecx
   pop eax

   add esp, 12
   pop ebp
   ret 4
reverseList ENDP
;==============================================================
rearrange PROC
   push ebp
   mov ebp, esp
   sub esp, 20; 5 * 4 = 20

   push edi
   push esi
   push eax
   push ecx
   push ebx
   push edx

   mov eax, [ebp+8] ; **head
   mov eax, [eax]   ; *head <= dereference
   mov ecx, [eax+4] ; (*head)->next "slow->next"

   mov [ebp-4], eax ; struct Node *slow = *head;
   mov [ebp-8], ecx ; struct Node *fast = slow->next

@while_loop:
   mov eax, [ebp-8] ; fast
   cmp eax, 0 
   je @out_side_loop
   mov ecx, [eax+4] ; fast->next
   cmp ecx, 0       ; while (fast && fast->next)
   je @out_side_loop

   mov eax, [ebp-4] ; slow
   mov eax, [eax+4]
   mov [ebp-4], eax ; slow = slow->next

   mov ecx, [ecx+4]
   mov [ebp-8], ecx ; fast = fast->next->next

   jmp @while_loop
@out_side_loop:

   mov eax, [ebp+8] ; **head
   mov edx, [eax]   ; *head

   mov ebx, [ebp-4] ; slow
   mov ecx, [ebx+4] ; slow->next

   mov [ebp-12], edx ; struct Node *head1 = *head;
   mov [ebp-16], ecx ; struct Node *head2 = slow->next
   
   xor ecx, ecx
   mov [ebx+4], ecx ; slow->next = NULL; 
   
   lea ecx, [ebp-16]
   push ecx
   call reverseList ; reverselist(&head2);
   
   xor ecx, ecx

   push ecx
   call newNode

   mov edx, [ebp+8] ; **head
   mov [edx], eax   ; *head = newNode(0); // Assign dummy Node

   mov edx, [edx] ; *head
   mov [ebp-20], edx ; Node *curr = *head;
@big_while_loop:
   mov eax, [ebp-12] ; head1
   mov ebx, [ebp-16] ; head2
   cmp eax, 0
   jne @not_NULL
   cmp ebx, 0
   jne @not_NULL    ;  while (head1 || head2)
   jmp @out_side_big_loop

@not_NULL:
   mov eax, [ebp-12] ; head1
   cmp eax, 0
   je @head1_is_NULL ; if (head1)
   mov edx, [ebp-20] ; curr
   mov [edx+4], eax  ; curr->next = head1
   
   mov edx, [edx+4]
   mov [ebp-20], edx ; curr = curr->next

   mov eax, [eax+4]
   mov [ebp-12], eax ; head1 = head1->next   

@head1_is_NULL:
  mov eax, [ebp-16] ; head2
  cmp eax, 0
  je @head2_is_NULL ; if (head2)
  mov edx, [ebp-20] ; curr
  mov [edx+4], eax  ; curr->next = head2
   
  mov edx, [edx+4]
  mov [ebp-20], edx ; curr = curr->next

  mov eax, [eax+4]
  mov [ebp-16], eax ; head2 = head2->next    
@head2_is_NULL:
   jmp  @big_while_loop

@out_side_big_loop:   

   mov eax, [ebp+8]; head

   mov edx, [eax]  ; *head
   mov edx, [edx+4]; (*head)->next 
   mov [eax], edx  ; *head2 = (*head)->next
    
   pop edx
   pop ebx
   pop ecx
   pop eax
   pop esi
   pop edi

   add esp, 20
   pop ebp
   ret 4
rearrange ENDP
;==============================================================
PrintArray PROC
    push ebp
	mov ebp, esp

	push ebx
	push eax
	push esi

.data
   szFmtLoc db '%d ', 0
   space db '                 ', 0
.code
    xor ebx, ebx
	mov esi, [ebp+8] ; Head of the linked list
@while_loop:
    cmp ebx, [ebp+12]
	jge @finish
	mov eax, [esi] ; data = node->data
	invoke crt_printf, OFFSET szFmtLoc, eax
	mov esi, [esi+4]
	inc ebx
	jmp @while_loop
.data
    szFmtNew db 10, 0 ; 0 is new line, aka: '\n'
.code
@finish:
    mov eax, 0
	invoke crt_printf, OFFSET space, eax

	pop esi
	pop eax
	pop ebx

	pop ebp
	ret 8
PrintArray ENDP
;==============================================================
main PROC
    push ebp
	mov ebp, esp
	sub esp, 16
	
	mov eax, 1
	push eax
	call newNode

	mov [ebp-4], eax ; Node *head = newNode(1);

	mov eax, 2
	push eax
	call newNode    

	mov edx, [ebp-4] ; head
	mov [edx+4], eax ;  head->next = newNode(2);

	mov eax, 3
	push eax
	call newNode

	mov edx, [ebp-4] ; head
	mov edx ,[edx+4]
	mov [edx+4], eax ; head->next->next = newNode(3);

	mov eax, 4
	push eax
	call newNode

	mov edx, [ebp-4] ; head
	mov edx ,[edx+4]
	mov edx, [edx+4]
	mov [edx+4], eax ; head->next->next->next = newNode(3);

	mov eax, 5
	push eax
	call newNode

	mov edx, [ebp-4] ; head
	mov edx ,[edx+4]
	mov edx, [edx+4]
	mov edx, [edx+4]
	mov [edx+4], eax ; head->next->next->next->next = newNode(3);

	mov eax, [ebp-4]
	push 5 ; 5 elemnts
	push eax;  push the head
	call PrintArray

	lea eax, [ebp-4]
	push eax
	call rearrange

	mov eax, [ebp-4]
	push 5 ; 5 elemnts
	push eax;  push the head
	call PrintArray

	add esp, 16
	pop ebp
	ret
main ENDP
END main