.386
.model flat, stdcall
.stack 8096

include msvcrt.inc
includelib msvcrt.lib

.data
    array DWORD -2h, -3h, 4h, -1h, -2h, 1h, 5h, -3h;
    max_sub_array_sum db 'Max sub array sum is: ', 0
    szFmtLoc db '%d', 0

.code

MaxSubArraySum PROC
    push ebp
    mov ebp, esp
    sub esp, 12 ; 4 dowrds

    push eax
    push ecx
    push edx

    xor ecx, ecx
    mov dword ptr [ebp-8], ecx  ; max_so_far = 0
    mov dword ptr [ebp-12], ecx ; max_ending_here = 0
    inc ecx
    mov dword ptr [ebp-4], ecx  ; i = 1
    
    jmp @first_time_jmp
@for_loop:
    mov ecx, dword ptr [ebp-4]
    inc ecx
    mov dword ptr [ebp-4], ecx
@first_time_jmp:
    cmp ecx, dword ptr [ebp+12]
    jge @out_side_for
    
    mov eax, dword ptr [ebp+8]
    mov edx, dword ptr [eax+ecx*4] ; a[i];

    mov eax, dword ptr [ebp-12]
    add eax, edx
    mov dword ptr [ebp-12], eax    ; max_ending_here = max_ending_here + a[i];

    cmp eax, 0
    jge @bigger_zero
    xor ecx, ecx
    mov dword ptr [ebp-12], ecx
@bigger_zero:

    mov ecx, dword ptr [ebp-12]
    
    cmp dword ptr [ebp-8], ecx
    jge @sec_bigger_zero
    mov dword ptr [ebp-8], ecx
@sec_bigger_zero:

    jmp @for_loop
@out_side_for:
    pop edx
    pop ecx
    pop eax

    mov eax, dword ptr [ebp-8]
    
    add esp, 12
    pop ebp
    ret 8
MaxSubArraySum ENDP

    main PROC
    push ebp
    mov ebp, esp
    sub esp, 4

    push 8
    push offset array
    call MaxSubArraySum
    
    mov dword ptr [ebp-4], eax

    invoke crt_printf, offset max_sub_array_sum
 
    mov eax, dword ptr [ebp-4]
    invoke crt_printf, offset szFmtLoc, eax

    add esp, 4
    pop ebp
    ret
main ENDP
END main