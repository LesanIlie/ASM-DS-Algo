.386
.MODEL flat, stdcall
.STACK

include msvcrt.inc
includelib msvcrt.lib

.data

.code

skipMdeleteN PROC
    push ebp
	mov ebp, esp
	sub esp, 16 ; 3 * 4 variabile locale
	
	push eax
	push ebx
	push ecx
	push esi
	push edi

	mov eax, [ebp+8] ; head
    mov [ebp-4], eax ; struct node *curr = head

@loop_while_not_null:  
    mov eax, [ebp-4] ; curr
	cmp eax, 0
	je @exit_loop

	    mov ecx, 1
	    mov [ebp-12], ecx ; count
	    jmp @first_for_jmp

	@for_loop:
	
	    ;incremnt counter 
	    mov ecx, [ebp-12]
	    inc ecx
	    mov [ebp-12], ecx; count++
	@first_for_jmp:
	    cmp ecx, [ebp+12] ;count < M
		jge @exit_for
		mov eax, [ebp-4]; curr
		cmp eax, 0
		je @exit_for
		mov eax, [eax+4] 
		mov [ebp-4], eax ; curr = curr->next
	    jmp @for_loop
	@exit_for: ; exit for

	   mov eax, [ebp-4]
	   cmp eax, 0
	   je @exit_loop ; if (curr == NULL) return

	   mov eax, [eax+4] 
	   mov [ebp-8], eax ; t = curr->next

	   mov ecx, 1
	   mov [ebp-12], ecx ; count
	   jmp @second_for_jmp

	@second_for_loop:
	
	   ;incremnt counter 
	   mov ecx, [ebp-12]
	   inc ecx
	   mov [ebp-12], ecx; count++
	
	@second_for_jmp:
	   cmp ecx, [ebp+16]
	   jg  @exit_second_loop ; count <= N
	   mov eax, [ebp-8]      ; t
	   cmp eax, 0
	   je @exit_second_loop  ; t != null
	   mov [ebp-16], eax     ; struct node *temp = t
	   mov edx, [eax+4]      
	   mov [ebp-8], edx      ; t = t->next

	   push eax
	   call crt_free
	   add esp, 4
       jmp @second_for_loop
	@exit_second_loop:

	mov eax, [ebp-4] ; curr
	mov edx, [ebp-8] ; t
	mov [eax+4], edx ; curr->next = t

	mov [ebp-4], edx ; curr = t

	jmp @loop_while_not_null

@exit_loop:

	pop edi
	pop esi
	pop ecx
	pop ebx
	pop eax
	
	add esp, 16
    pop ebp
	ret 12
skipMdeleteN ENDP

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

   mov [ebp-4], eax ; MewNode = malloc(sizeof(struct node))
   
   mov ecx, [ebp+12] ; second parameter from stack
   mov [eax], ecx

   mov ecx, [ebp+8]
   mov ebx, [ecx]

   mov [eax+4], ebx
   mov [ecx], eax

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
   szFmtLoc db '%d ', 0
.code
    xor ebx, ebx
	mov esi, [ebp+8]
@while_loop:
    cmp ebx, [ebp+12]
	jge @finish
	mov eax, [esi]
	invoke crt_printf, OFFSET szFmtLoc, eax
	mov esi, [esi+4]
	inc ebx
	jmp @while_loop
.data
    szFmtNew db '\n' , 0; 0 is new line, aka: '\n'
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
	sub esp, 4

	push eax

	xor eax, eax
	mov[ebp-4], eax
	
	push 10
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 9
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 8
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 7
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 6
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 5
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 4
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 3
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 2
	lea eax, [ebp-4]
	push eax
	call PushNode

	push 1
	lea eax, [ebp-4]
	push eax
	call PushNode

	mov eax, [ebp-4]
	push 10
	push eax
	call PrintArray
	
	push 3 ; N
	push 2 ; M
	mov eax, [ebp-4]
	push eax
	call skipMdeleteN

	mov eax, [ebp-4]
	push 4
	push eax
	call PrintArray
	
	pop eax

	add esp, 4
	pop ebp
	ret

main ENDP
END main