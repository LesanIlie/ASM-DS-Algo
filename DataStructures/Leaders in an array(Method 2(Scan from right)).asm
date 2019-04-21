.386
.model flat, stdcall
.stack 8096

include msvcrt.inc
includelib msvcrt.lib

.data 
    array DWORD 16, 17, 4, 3, 5, 2
    szFmtLoc db '%d ', 0
 .code

 PrintLeaders PROC
     push ebp
     mov ebp, esp
     sub esp, 8

     push eax
     push ebx
     push ecx
     push edx

     mov eax, dword ptr[ebp+8]     ; arr 
     mov ecx, dword ptr[ebp+12]    ; size
     dec ecx                       ; size - 1
     mov edx, dword ptr[eax+ecx*4] ; arr[size-1]
     mov dword ptr[ebp-4], edx     ; max_from_right = arr[size-1]
     
     push edx
     push offset szFmtLoc
     call crt_printf
     add esp, 8
      
     mov ecx, dword ptr[ebp+12]    ; size
     dec ecx                       ; size - 1
     dec ecx                       ; size - 2

     mov dword ptr[ebp-8], ecx ; i = size - 2 
     jmp @first_jmp 
@for_loop:
     mov ecx, dword ptr[ebp-8]
     dec ecx
     mov dword ptr[ebp-8], ecx ; i-- 
@first_jmp:
     cmp ecx, 0
     jl @exit_for
     ;-------------------------------------
     mov ebx, dword ptr[ebp-4]     ; max_from_rights
     mov eax, dword ptr[ebp+8]     ; arr
     mov edx, dword ptr[eax+ecx*4] ; arr[i]

     cmp ebx, edx
     jge @not_leader

     mov dword ptr[ebp-4], edx
     
     push edx
     push offset szFmtLoc
     call crt_printf 
     add esp, 8
     
@not_leader:

     ;-------------------------------------
     jmp @for_loop
@exit_for:
     pop edx
     pop ecx
     pop ebx
     pop eax

     add esp, 8
     pop ebp
     ret 8
 PrintLeaders ENDP

 main PROC
     push ebp
     mov ebp, esp

     push 6
     push offset array
     call PrintLeaders

     pop ebp 
     ret
 main ENDP
 END main