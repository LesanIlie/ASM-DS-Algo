.386
.model flat, stdcall
.stack 8096

include msvcrt.inc
includelib msvcrt.lib

.data

    array DWORD 01h, 02h, 03h, 03h, 02h, 00h
    szFmtLoc db '%s ', 0
    szMajority db 'Majority', 0
    szNoMajority db 'No Majority', 0
.code

IsMajority PROC
    push ebp
    mov ebp, esp
    sub esp, 8

    push eax
    push ebx
    push ecx
    push edx

    xor ecx, ecx
    mov dword ptr[ebp-4], ecx ; i = 0;
    mov dword ptr[ebp-8], ecx ; count = 0

    jmp @first_time_jmp
@for_loop:
    mov ecx, dword ptr [ebp-4]
    inc ecx
    mov dword ptr [ebp-4], ecx
@first_time_jmp:
    cmp ecx, dword ptr [ebp+12]
    jge @out_side_for 

    mov ebx, dword ptr[ebp+8]      ; array
    mov edx, dword ptr [ebp+16]    ; cand
    cmp dword ptr [ebx+ecx*4], edx ; if (a[i] == cand)
    jne @not_equal
    mov ecx, dword ptr [ebp-8]
    inc ecx
    mov dword ptr [ebp-8], ecx     ; count++
@not_equal:
    jmp @for_loop
@out_side_for:

    xor edx, edx                  ; clear edx before devide
    mov eax, dword ptr [ebp+12]   ; size
    mov ecx, 2
    div ecx

    mov ebx, dword ptr [ebp-8]    ; count

    cmp ebx, eax 
    jg  @grather                 ; if (count > size / 2)
    xor ecx, ecx
    mov dword ptr [ebp-4], ecx    ; return 0
    jmp @end
@grather:
    mov ecx, 1
    mov dword ptr [ebp-4], ecx    ; return 1
@end:
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov eax, dword ptr [ebp-4]
    add esp, 8
    pop ebp
    ret 12
IsMajority ENDP

FindCandidate PROC
    push ebp
    mov ebp, esp
    sub esp, 12 ; 3 elmentes of 4 bytes
    
    push eax
    push ebx
    push ecx
    push edx

    xor ecx, ecx ; zero
    mov dword ptr [ebp-4], ecx ; max_index = 0
    
    inc ecx
    mov dword ptr [ebp-8], ecx ; count = 1

    ; *************BLOCK***************
    mov dword ptr [ebp-12], ecx ; i = 1
    jmp @first_time_jmp
@for_loop:
    mov ecx, dword ptr [ebp-12]  ; 
    inc ecx
    mov dword ptr [ebp-12], ecx  ; i++
 @first_time_jmp:
    cmp ecx, dword ptr [ebp+12]  ; i < size <= in for loop
    jge @exit_for_loop
    
    mov ebx, dword ptr [ebp-4]
    mov edx, dword ptr [ebp+8]   ; array[max_index]

    mov eax, dword ptr [edx+ecx*4]

    cmp dword ptr [edx+ebx*4], eax 
    jne @not_equal               ;   if (a[max_index] == a[i]) in revers,(adica if (a[max_index] == a[i]))
    ; count++
    mov ecx, dword ptr[ebp-8]
    inc ecx
    mov dword ptr[ebp-8], ecx
    jmp @check_if_zero
@not_equal:
    ; count--
    
    mov ecx, dword ptr[ebp-8]
    dec ecx
    mov dword ptr[ebp-8], ecx
@check_if_zero:
    
    cmp ecx, 0
    jne @not_zero              ; if (count == 0)
    mov ecx, 1
    mov dword ptr [ebp-8], ecx ; count = 1;
    
    mov edx, dword ptr [ebp-12]; i
    mov dword ptr [ebp-4], edx ; max_index = i;

@not_zero:
    jmp @for_loop ; loop back
@exit_for_loop:
   
    ; *************BLOCK***************
    mov ecx, dword ptr [ebp-4]     ; max_index
    mov eax, dword ptr [ebp+8]     ; array
    
    mov ebx, dword ptr [eax+ecx*4] ; array[max_index]
    
    mov dword ptr [ebp-4], ebx     ; return array[max_index]
     
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    mov eax, dword ptr [ebp-4]
    
    add esp, 12
    pop ebp
    ret 8

FindCandidate ENDP

PrintMajority PROC
    push ebp
    mov ebp, esp
    sub esp, 4 ; sizeof(int)

    push eax
    
    push dword ptr [ebp+12] ; size
    push dword ptr [ebp+8]  ; array
    call FindCandidate

    mov dword ptr [ebp-4], eax ; Cand = FindCandidate(a, size);

    push dword ptr [ebp-4]  ; cand
    push dword ptr [ebp+12] ; size
    push dword ptr [ebp+8]  ; array
    call IsMajority         ; isMajority(a, size, Cand)
    
    cmp eax, 0
    je @no_majority
    
    invoke crt_printf, offset szMajority
    jmp @end
     
@no_majority:
    invoke crt_printf, offset szNoMajority
@end:
    pop eax

    add esp, 4
    pop ebp
    ret 8     ; two elements as parameters 
PrintMajority ENDP

main PROC
    push ebp
    mov ebp, esp
    
    push 5
    push offset array
    call PrintMajority

    pop ebp
    ret
    
main ENDP
END main