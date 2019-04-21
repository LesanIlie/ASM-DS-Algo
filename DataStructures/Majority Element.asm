.386
.MODEL flat, stdcall
.STACK 8096

include msvcrt.inc
includelib msvcrt.lib

.data
.code

printMajority PROC
   push ebp
   mov ebp, esp
   sub esp, 4
   
   push eax
   push ebx
   push ecx
   push edx

   mov edx, [ebp+8]  ; a
   mov ecx, [ebp+12] ;size

   push ecx
   push edx
   call findCandidate
   mov [ebp-4], eax

   mov ecx, [ebp+12] ;size

   push eax ; cand
   push ecx ; size 
   push edx ; a
   call isMajority
   mov ecx, eax

   .data
   fmt db '%s',0 
   maj db 'Majority',0
   notmaj db 'NotMajority',0
   .code
   cmp eax, 0
   je @not_majority
   mov eax, offset maj
   invoke crt_printf, offset fmt, eax  
   jmp @exit
 @not_majority:
   mov eax, offset notmaj
   invoke crt_printf, offset fmt, eax  
   
 @exit:
   pop edx
   pop ecx
   pop ebx
   pop eax
   
   add esp, 4
   pop ebp
   ret 8
printMajority ENDP

findCandidate PROC
   push ebp
   mov ebp, esp
   sub esp, 3*4

   push eax
   push ebx
   push ecx
   push edx
   
   xor ecx, ecx
   mov [ebp-4], ecx ; max_index = 0
   inc ecx
   mov[ebp-8], ecx  ; count = 1

   mov [ebp-12], ecx ; i = 1
   jmp @first_jmp_for

@for_loop:
   mov eax, [ebp-12]
   inc eax
   mov [ebp-12], eax
@first_jmp_for:
   mov eax, [ebp-12]
   cmp eax, [ebp+12]
   jge @exit_loop 
       mov ebx, [ebp-4]     ; max_index
       mov edx, [ebp+8]     ; a
       mov ecx, [edx+ebx*4] ; a[max_index]
       mov eax, [ebp-12]    ; i
       mov edi, [edx+eax*4] ; a[i]
	   cmp ecx, edi
	   je @equal
	       mov ecx, [ebp-8]
	       dec ecx              ; count--;
	       mov [ebp-8], ecx
	   jmp @out_if_else
       @equal:
	       mov ecx, [ebp-8]
	       inc ecx             ; count++;
	       mov [ebp-8], ecx
       @out_if_else:

	   cmp ecx, 0
	   jne @not_equal
	   mov ecx, [ebp-12]
	   mov [ebp-4], ecx   ; max_index = i;
	   mov ecx, 1         ; count = 1;
	   mov [ebp-8], ecx
	   @not_equal:
   jmp @for_loop
@exit_loop:
   pop edx
   pop ecx
   pop ebx
   pop eax

   mov ecx, [ebp-4]     ; max_index
   mov edx, [ebp+8]     ; a
   mov eax, [edx+ecx*4] ; return a[max_index]
   add esp, 3*4
   pop ebp
   ret 8
findCandidate ENDP

isMajority PROC
   push ebp
   mov ebp, esp
   sub esp, 12 ; 12 bytes in stack
   push eax
   push ecx
   push edx
   push ebx

   xor ecx, ecx
   mov [ebp-8], ecx ; count = 0
   mov [ebp-4], ecx ; i = 0

   jmp @first_time_jmp
@for_loop:
   mov ecx, [ebp-4]
   inc ecx
   mov [ebp-4], ecx
@first_time_jmp:
   mov ecx, [ebp-4]  ; i
   cmp ecx, [ebp+12] ; size
   jge @out_side_for
       mov eax, [ebp+8]     ; a
	   mov ebx, [eax+4*ecx] ; a[i]
	   cmp ebx, [ebp+16]    ; if (a[i] == cand)
	   jne @not_equal
	   mov ecx, [ebp-8]
	   inc ecx
	   mov [ebp-8], ecx
	   @not_equal:
jmp @for_loop
@out_side_for:
   mov eax, [ebp+12] ; size
   mov ebx, 2
   cdq 
   idiv ebx ; size / 2
   cmp [ebp-8], eax
   jg @one
       xor eax, eax
       mov [ebp-12], eax; return 0
       jmp @pop_stack
@one:
       mov eax, 1
       mov [ebp-12], eax ; return 1
@pop_stack:
   pop ebx
   pop edx
   pop ecx
   pop eax

   mov eax, [ebp-12] ; return val stored in EAX
   
   add esp, 12 ; get ride of 12 allocate bytes on stack 
   pop ebp
   ret 12
isMajority ENDP

main PROC
   push ebp
   mov ebp, esp
   sub esp, 6*4 ; 24 bytes

   push eax
   push ecx
   push edx
   push ebx

   mov eax, 1
   mov [ebp-4], eax

   mov eax, 3
   mov [ebp-8], eax
   
   mov eax, 2
   mov [ebp-12], eax
   
   mov eax, 3
   mov [ebp-16], eax
   
   mov eax, 3
   mov [ebp-20], eax
   
   mov eax, 2
   mov [ebp-24], eax
 
   push 5
   lea eax, [ebp-24]
   push eax
   call printMajority
   
   pop ebx
   pop edx
   pop ecx
   pop eax

   add esp, 6*4 ; 24 bytes
   pop ebp
   ret
; Add code
main ENDP
END main