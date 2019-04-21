.386
.MODEL flat, stdcall
include msvcrt.inc
includelib msvcrt.lib


.data
;Data here
.code

PushNode PROC
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

	mov [ebp-4], eax ; NewNode = malloc(sizeof(struct node));
	
	mov ecx, [ebp+12] ; Second parameter from stack
	mov [eax], ecx    ; NewNode->data = data

	mov ecx, [ebp+8]  ; First parameter from stack
	mov ebx, [ecx]    ; Get the head, ex: (*head_ref)

	mov [eax+4], ebx  ; NewNode->Next = (*head_ref)
	mov [ecx], eax    ; (*head_ref) = NewNode <= change the head

	pop edi
	pop esi
	pop ecx
	pop ebx
	pop eax

	add esp, 4
	pop ebp
	ret 8
PushNode ENDP

IsPressent PROC
   push ebp
   mov ebp, esp
   sub esp, 4 ; Allocate space on stack

   push eax
   push ebx
   push ecx
   push esi
   push edi
   
   mov eax, [ebp+8] ; here is the head
   mov [ebp-4], eax ; struct node *t = head

@while_loop:
  mov eax, [ebp-4]
  cmp eax, 0
  je @exit_while_zero

  mov ecx, [eax]; t->data
  cmp ecx, [ebp+12]
  je @equal
  mov eax, [eax+4] ; 
  mov [ebp-4], eax

  jmp @while_loop   
@exit_while_zero: 
  xor ecx, ecx
  mov [ebp-4], ecx ; return zero
  jmp @exit

@equal:
  mov ecx, 1
  mov [ebp-4], ecx ; return zero

@exit:
   pop edi
   pop esi
   pop ecx
   pop ebx
   pop eax

   mov eax, [ebp-4] ; return val

   add esp, 4
   pop ebp
   ret 8
IsPressent ENDP

PrintArray PROC
    push ebp
	mov ebp, esp

	push ebx
	push eax
	push esi

.data
   szFmtLoc db '%d ', 0
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
    mov eax, 0
	invoke crt_printf, OFFSET szFmtNew, eax
@finish:
	pop esi
	pop eax
	pop ebx

	pop ebp
	ret 8
PrintArray ENDP
    

getIntersection PROC
    push ebp
	mov ebp, esp
	sub esp, 8

	push eax
    push ebx
    push ecx
    push esi
    push edi
   
    xor ecx, ecx
	mov [ebp-4], ecx ; struct node *result = NULL
	
	mov eax, [ebp+8]
	mov [ebp-8], eax ; struct node *t1 = head1

@while_loop:
    mov eax, [ebp-8]
	cmp eax, 0
	je @exit_while_loop

	mov eax, [eax] ; t1->data
	push eax
	mov ecx, [ebp+12] ; head2
	push ecx
	call IsPressent ; if (isPresent(head2, t1->data))

	cmp eax, 0
	je @not_pressent	
	mov eax, [ebp-8]
	mov eax, [eax] ;t1->data
	lea ecx, [ebp-4] ; &result
	
	push eax ; t1->data
	push ecx ; &result
	call PushNode ; push(&result, t1->data);

@not_pressent:
	mov ecx, [ebp-8] ; t1
	mov ecx, [ecx+4]
	mov [ebp-8], ecx ; t1 = t1->next
	jmp @while_loop
@exit_while_loop:
  
	pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax

	mov eax, [ebp-4] ; return result;
	add esp, 8
	pop ebp
	ret 8
getIntersection ENDP


main PROC
    push ebp
	mov ebp, esp
	sub esp, 16
	push eax
	
	xor eax, eax
	mov[ebp-4], eax

	push 20
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 4
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 15
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 10
	lea eax, [ebp-4]
	push eax
	call PushNode

	xor eax, eax
	mov[ebp-8], eax

	push 10
	lea eax, [ebp-8]
	push eax
	call PushNode

	push 2
	lea eax, [ebp-8]
	push eax
	call PushNode

	push 4
	lea eax, [ebp-8]
	push eax
	call PushNode

	push 8
	lea eax, [ebp-8]
	push eax
	call PushNode

	mov eax, [ebp-8]
	mov ecx, [ebp-4]
	push eax
	push ecx
	call getIntersection

	push 2
	push eax
	call PrintArray

	pop eax
	
	add esp, 16
	pop ebp
	ret
main ENDP
END main