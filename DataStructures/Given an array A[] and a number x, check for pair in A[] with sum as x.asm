.386
.MODEL flat, stdcall
.STACK 8096

include msvcrt.inc
includelib msvcrt.lib

.data

array DWORD 1h, 7h, 5h, 5h, 3h, 2h, 3h, 9h, 8h, 3h, 6h, 00h
MAX DWORD 10
.code
;==================================================================
printPairs PROC
  push ebp    ; save the stack frame
  mov ebp, esp
  sub esp, 52
  push eax
  push ecx
  push edx
  push ebx
  push edi
  push esi

  lea edi, [ebp-12]
  xor eax, eax         ; clear the array
  mov ecx, 10
  std                  ; direction backward, because 
  rep stosd            ; stack grows to low adresses

  xor ecx, ecx
  mov [ebp-4], ecx   ; i = 0
  jmp @for_init
@for_loop:
 mov ecx, [ebp-4]
 inc ecx
 mov [ebp-4], ecx    ; i++
@for_init:
 cmp ecx, [ebp+12]   ; i < array_size
 jge @exit           ; exit loop
 mov edx, [ebp+16]   ; sum
 mov edi, [ebp+8]    ; arr
 mov esi, [edi+ecx*4]; arr[i] 
 sub edx, esi        ; sum - arr[i];
 mov [ebp-8], edx    ; temp = sum - arr[i]

 lea ecx, [ebp-12]   ; binMap
 sub ecx, 40         ; space allocated
 mov ebx, [ecx+edx*4]; binMap[temp]

 cmp edx, 0          ; EDX == temp
 jnge @out_if        ; temp >= 0, jump not greather equal 
 cmp ebx, 1          ; binMap[temp] == 1
 jne @out_if
 ;_________________
 ; result
 mov eax, edx        ; first number
 mov ecx, esi        ; second number
 ;_________________
 
@out_if:
 mov edi, [ebp+8]    ; arr
 mov ecx, [ebp-4]    ; i
 mov esi, [edi+ecx*4]; arr[i]
 mov edx, 1
 lea ecx, [ebp-12]   ; binMap
 sub ecx, 40         ; space allocated
 mov [ecx+esi*4], edx; binMap[arr[i]] = 1;
  
 jmp @for_loop
@exit:
  pop esi
  pop edi
  pop ebx
  pop edx
  pop ecx
  pop eax

  add esp, 52
  pop ebp ; restore the stack frame
  ret 12
printPairs ENDP	
;==================================================================
main PROC
   
   push 45
   push 10
   push offset array
   call printPairs
   ret 8
main ENDP
END main
