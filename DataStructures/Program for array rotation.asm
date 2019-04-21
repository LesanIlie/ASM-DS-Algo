.386
.model flat, stdcall
.stack 8096

include msvcrt.inc
includelib msvcrt.lib

.data 
    array DWORD 1h, 2h, 3h, 4h, 5h, 6h, 7h
    before db 'Array before: ', 0
    after db 'Array after: ', 0
    szFmtLoc db '%d ', 0
.code
LeftRotateByOne PROC
    push ebp
    mov ebp, esp
    sub esp, 8

    push eax
    push ecx
    push ebx
    push edx
    
    mov eax, dword ptr [ebp+8] ; arr
    mov edx, dword ptr [eax]    ; arr[0]
    mov dword ptr [ebp-8], edx ; temp = arr[0]

    xor ecx, ecx
    mov dword ptr [ebp-4], ecx
    jmp @first_jmp
@for_loop:
    mov ecx, dword ptr [ebp-4]
    inc ecx
    mov dword ptr [ebp-4], ecx
@first_jmp:
    mov eax, dword ptr [ebp+12]; n
    dec eax
    cmp ecx, eax               ; n-1 
    jge @exit_loop
    
    mov eax, dword ptr [ebp+8]     ; arr
    mov ecx, dword ptr [ebp-4]     ; i
    
    inc ecx                        ; i + 1
    mov edx, dword ptr [eax+ecx*4]
    dec ecx                        ; i - 1
    mov dword ptr [eax+ecx*4], edx ; arr[i] = arr[i+1]
    jmp @for_loop
@exit_loop:
    
    mov eax, dword ptr [ebp+8]     ; arr
    mov ecx, dword ptr [ebp-4]     ; i
    
    mov edx, dword ptr [ebp-8]     ; temp
    mov dword ptr [eax+ecx*4], edx

    pop edx
    pop ebx
    pop ecx
    pop eax

    add esp, 8
    pop ebp
    ret 8
LeftRotateByOne ENDP

LeftRotate PROC
    push ebp
    mov ebp, esp
    sub esp, 4

    push eax
    push ecx

    xor ecx, ecx
    mov dword ptr [ebp-4], ecx
    jmp @first_jmp
@for_loop:
    mov ecx, dword ptr [ebp-4]
    inc ecx
    mov dword ptr [ebp-4], ecx
@first_jmp:
    mov eax, dword ptr [ebp+12]; d
    cmp ecx, eax   
    jge @exit_loop
   
    push dword ptr [ebp+16]
    push dword ptr [ebp+8]
    call LeftRotateByOne

    jmp @for_loop
@exit_loop:
    pop ecx
    pop eax
    
    add esp, 4
    pop ebp
    ret 12
LeftRotate ENDP

PrintArray PROC
    push ebp
    mov ebp, esp
    sub esp, 4

    push eax
    push ecx
    push ebx
    push edx

    xor ecx, ecx
    mov dword ptr [ebp-4], ecx
    jmp @first_jmp
@for_loop:
    mov ecx, dword ptr [ebp-4]
    inc ecx
    mov dword ptr [ebp-4], ecx
@first_jmp:
    mov eax, dword ptr [ebp+12]    ; size
    cmp ecx, eax   
    jge @exit_loop
    mov edx, dword ptr [ebp+8]     ; arr
    mov ebx, dword ptr [edx+ecx*4] ; arr[i]

    invoke crt_printf, offset szFmtLoc, ebx

    jmp @for_loop
@exit_loop:
    
    pop edx
    pop ebx
    pop ecx
    pop eax

    add esp, 4
    pop ebp
    ret 8
PrintArray ENDP


main PROC
    push ebp
    mov ebp, esp
    
    invoke crt_printf, offset before

    push 7
    push offset array
    call PrintArray

    push 7
    push 4
    push offset array
    call LeftRotate

    invoke crt_printf, offset after
   
    push 7
    push offset array
    call PrintArray

    pop ebp
    ret
main ENDP
END main