.386
.model flat, stdcall
.stack 8096

include msvcrt.inc
includelib msvcrt.lib

.data
    array DWORD 12, 13, 1, 10, 34, 1
    szFmtLoc DB '%d ', 0
    NoSmallest DB 'There is no second smallest element', 0
    InvalidInput DB 'Invalid input', 0
    Smallest DB 'The smallest element is %d and second Smallest element is %d', 0
.code
print2Smallest PROC
    push ebp
    mov ebp, esp
    sub esp, 12

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ecx, dword ptr[ebp+12]
    cmp ecx, 2
    jge @grather_than_two ;signed comparation
 
    ; Invalid input
    invoke crt_printf, offset InvalidInput
 
    jmp @exit
@grather_than_two:

    mov eax, 07FFFFFFFh
    mov dword ptr[ebp-8], eax  ; first = INT_MAX
    mov dword ptr[ebp-12], eax ; second = INT_MAX
    xor eax, eax
    mov dword ptr[ebp-4], eax  ; i = 0
    jmp @first_time_jmp
@for_loop:
    mov eax, dword ptr[ebp-4]
    inc eax
    mov dword ptr[ebp-4], eax
@first_time_jmp:
    cmp eax, dword ptr[ebp+12]
    jge @outside_for              ; signed comparation
    
    mov ebx, dword ptr[ebp+8]     ; arr
    mov ecx, dword ptr[ebx+eax*4] ; arr[i]

    cmp ecx, dword ptr[ebp-8]
    jge @not_small
    mov edi, dword ptr[ebp-8]  ; first
    mov dword ptr[ebp-12], edi ; second = first
    mov dword ptr[ebp-8], ecx  ; first = arr[i]
    jmp @not_in_middle
@not_small:
    cmp ecx, dword ptr[ebp-12] ; else if (arr[i] < second && arr[i] != first)
    jge @not_in_middle         ; signed comparation
    cmp ecx, dword ptr[ebp-8]  ;  second = arr[i];
    je @not_in_middle
    mov dword ptr[ebp-12], ecx
@not_in_middle:
    jmp @for_loop
@outside_for:
    mov eax, 07FFFFFFFh
    cmp dword ptr[ebp-12], eax
    jne @print_smallest
    
    ; Invalid input
    invoke crt_printf, offset NoSmallest
 
    jmp @exit
@print_smallest:
   ; printf("The smallest element is %d and second "
   ;        "Smallest element is %d\n", first, second);
   mov eax, dword ptr[ebp-8]
   mov ecx, dword ptr[ebp-12]

   invoke crt_printf, offset Smallest, eax, ecx
@exit:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    add esp, 12
    pop ebp
    ret 8
print2Smallest ENDP

main PROC
    push ebp
    mov ebp, esp

    push 6
    push offset array
    call print2Smallest
    pop ebp
    ret
main ENDP
END main