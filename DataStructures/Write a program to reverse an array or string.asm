.386
.model flat, stdcall
.stack 8096

include msvcrt.inc
includelib msvcrt.lib

.data
    array DWORD 1h, 2h, 3h, 4h, 5h, 6h
    
.code

 ReverseArray PROC
     push ebp
     mov ebp, esp
     sub esp, 4

     push eax
     push ebx
     push ecx
     push edx
     push esi

@while_loop:
     mov ecx, dword ptr [ebp+12]    ; start
     cmp ecx, dword ptr [ebp+16]
     jge @exit_loop
     mov eax, dword ptr [ebp+8]     ; array
     mov ebx, dword ptr [eax+ecx*4] ; array[start]
     
     mov edx, dword ptr [ebp+16]    ; end
     mov esi, dword ptr [eax+edx*4] ; array[end]

     mov dword ptr [eax+ecx*4], esi ; array[start] = array[end]

     mov dword ptr [eax+edx*4], ebx ; arry[end] = array[start]

     mov ecx, dword ptr [ebp+12]
     inc ecx
     mov dword ptr [ebp+12], ecx    ; start++

     mov ecx, dword ptr [ebp+16]
     dec ecx
     mov dword ptr [ebp+16], ecx    ; end--

     jmp @while_loop
@exit_loop:
     pop esi
     pop edx
     pop ecx
     pop ebx
     pop eax

     add esp, 4
     pop ebp
     ret 12

 ReverseArray ENDP

 main PROC
     push ebp
     mov ebp, esp

     push 5
     push 0
     push offset array
     call ReverseArray
     ;****************************************************;
     ; WRITE A FUNCTION  TO PRINT THE ARRAY               ;
     ;****************************************************;
     pop ebp
     ret
 main ENDP
 END main