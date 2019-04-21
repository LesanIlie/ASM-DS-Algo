.386
.model flat, stdcall

include msvcrt.inc
includelib msvcrt.lib

.data 
    array DWORD 1, 60, 85, -10, -80, 70
    szFmtLoc db '%d ', 0
    invalid db 'Invalid input', 0
.code
MinAbsSumPair PROC
    push ebp
    mov ebp, esp
    sub esp, 4*7

    push eax
    push ebx
    push ecx
    push edx
    push edi
    push esi
    
    xor ecx, ecx
    mov dword ptr[ebp-4], ecx ; int inv_count = 0
   
    mov ebx, dword ptr[ebp+12]
    cmp ebx, 2
    jge @valid_input
 
    ; Invalid input
    invoke crt_printf, offset invalid

    jmp @exit
@valid_input:

    mov dword ptr[ebp-24], ecx  ;min_l 
    mov dword ptr[ebp-8], ecx   ; l  
    inc ecx                     ; 1
    mov dword ptr[ebp-28], ecx  ; min_r

    xor ecx, ecx
    mov eax, dword ptr[ebp+8]     ; arr
    mov edx, dword ptr[eax+ecx*4] ; arr[0]
    inc ecx
    add edx, dword ptr[eax+ecx*4] ; arr[1]
    mov dword ptr[ebp-16], edx    ; min_sum = arr[0] + arr[1]  
    ;----------------------------------------
    mov ecx, dword ptr[ebp-8]
    jmp @first_time_jmp
@first_for_loop:
    mov ecx, dword ptr[ebp-8]
    inc ecx 
    mov dword ptr[ebp-8], ecx
@first_time_jmp: 
   mov edx, dword ptr[ebp+12]
   dec edx                   ; arry_size - 1 
   cmp ecx, edx              ; l < arry_size - 1
   jge @exit_first_loop
   ;-----------------------------------------
   mov ecx, dword ptr[ebp-8]
   inc ecx
   mov dword ptr[ebp-12], ecx ; r = l + 1
   jmp @first_jmp_second_loop
@second_for_loop:
   mov ecx, dword ptr[ebp-12]
   inc ecx
   mov dword ptr[ebp-12], ecx
@first_jmp_second_loop:
   cmp ecx, dword ptr[ebp+12] ; r < arr_size
   jge @exit_second_loop
   ;==================================

   mov ecx, dword ptr[ebp+8]     ; arr
   mov ebx, dword ptr[ebp-8]     ; l
   mov edx, dword ptr[ebp-12]    ; r

   mov eax, dword ptr[ecx+ebx*4]
   add eax, dword ptr[ecx+edx*4] 
   mov dword ptr[ebp-20], eax    ; sum = arr[l] + arr[r]

   push dword ptr [ebp-16]
   call crt_abs
   mov edx, eax                  ; abs(min_sum)
   
   push dword ptr [ebp-20]
   call crt_abs                  ; abs(sum)

   cmp edx, eax
   jle @bigger
   mov ecx, dword ptr[ebp-20]
   mov dword ptr[ebp-16], ecx    ; min_sum = sum

   mov edx, dword ptr[ebp-8]
   mov dword ptr[ebp-24], edx ; min_l = l
   
   mov edx, dword ptr[ebp-12]
   mov dword ptr[ebp-28], edx ; min_r = r

@bigger:
   ;==================================
   jmp @second_for_loop
@exit_second_loop:
   ;-----------------------------------------
   jmp @first_for_loop
@exit_first_loop:
    ;----------------------------------------

 @exit:

    mov eax, dword ptr[ebp-24] ; min_l
    mov edx, dword ptr[ebp+8]
    mov ebx, dword ptr[edx+eax*4]
    invoke crt_printf, offset szFmtLoc, ebx ; printf(" %d\n", arr[i]);

    mov eax, dword ptr[ebp-28] ; min_r
    mov edx, dword ptr[ebp+8]
    mov ebx, dword ptr[edx+eax*4]
    invoke crt_printf, offset szFmtLoc, ebx ; printf(" %d\n", arr[i]);

    pop esi
    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax

    pop ebp
    ret 8
MinAbsSumPair ENDP

main PROC
    push ebp
    mov ebp, esp

    push 6
    push offset array
    call MinAbsSumPair
    pop ebp 
    ret
main ENDP
END main