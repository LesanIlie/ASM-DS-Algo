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
    push esi
    push edi

    xor ecx, ecx
    mov dword ptr[ebp-4], ecx ; i = 0
    jmp @first_time
@for_loop:
    mov ecx, dword ptr[ebp-4]
    inc ecx
    mov dword ptr[ebp-4], ecx ; i++
@first_time:
    cmp ecx, dword ptr[ebp+12]; i < size
    jge @exit_for_loop
    ;---------------------------------------
    mov eax, dword ptr[ebp-4] ;i
    inc eax
    mov dword ptr[ebp-8], eax ; j = i + 1;
    jmp @first_jmp_second_loop
@second_loop:
    mov eax, dword ptr[ebp-8] ; j
    inc eax
    mov dword ptr[ebp-8], eax 
@first_jmp_second_loop:
    cmp eax, dword ptr[ebp+12]; j < size
    jge @exit_second_loop
    ;---------------------------------------
    mov edx, dword ptr[ebp+8]
    mov esi, dword ptr[edx+eax*4]; arr[j]
    mov edi, dword ptr[edx+ecx*4]; arr[i]
    cmp edi, esi                 ; if (arr[i] <= arr[j])
    jle @exit_second_loop        ; break
    ;---------------------------------------
    jmp @second_loop
@exit_second_loop:
    mov ecx, dword ptr[ebp-8]
    cmp ecx, dword ptr[ebp+12]
    jne @not_equal                          ; if (j == size)
    mov edx, dword ptr[ebp+8]               ; arr
    mov ecx, dword ptr[ebp-4]               ; i
    mov eax, dword ptr[edx+ecx*4]           ; arr[i]
    invoke crt_printf, offset szFmtLoc, eax ; printf(" %d\n", arr[i]);
    
@not_equal:
    ;---------------------------------------
    jmp @for_loop
@exit_for_loop:
    pop edi
    pop esi
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