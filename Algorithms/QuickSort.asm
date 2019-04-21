.386
.MODEL flat, stdcall
.STACK 8096

include msvcrt.inc
includelib msvcrt.lib

.data

MaxHeap STRUCT
     SizeArray DWORD ?
     Array     DWORD ?
MaxHeap ENDS

array DWORD 13h, 11h, 15h, 9h, 23h, 1h, 43h, 45h, 23h, 23h, 12h, 00h
L     DWORD 00h,00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h  ;100 elements and initialize all with zero
R     DWORD 00h,00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

MaxHeap<0, 0>

.code
;==================================================================

swap PROC
    push ebp
    mov ebp, esp
    sub esp, 4

    push eax
    push ebx
    push ecx

    mov eax, [ebp+8]
    mov ebx, [eax]
    mov [ebp-4], ebx  ; t = *a

    mov ebx, [ebp+12]
    mov ecx, [ebx]
    mov [eax], ecx    ; *a = *b

    mov eax, [ebp-4]
    mov [ebx], eax    ; *b = t

    pop ecx
    pop ebx
    pop eax
    add esp, 4
    pop ebp
    ret 8
swap ENDP

;==================================================================
partition PROC
   push ebp
   mov ebp, esp
   sub esp, 12
   
   push eax
   push ebx
   push ecx
   push edx
   push esi
   push edi
   
   mov ecx, [ebp+16]    ; h
   mov eax, [ebp+8]     ; arr
   mov edx, [eax+ecx*4] ; arr[h]  
   mov [ebp-4], edx     ; x = arr[h]

   mov ecx, [ebp+12]    ; l
   dec ecx
   mov [ebp-8], ecx     ; i = l-1
   
   mov ecx, [ebp+12]    ; l
   mov [ebp-12], ecx    ; j = l 
   jmp @first_for_jmp

@for_loop:
   mov ecx, [ebp-12]
   inc ecx
   mov [ebp-12], ecx   ; j++
@first_for_jmp:
   mov edx, [ebp+16]   ; h 
   dec edx             ; h - 1
   cmp ecx, edx        ; j <= h-1
   jg @out_side_for    ; for (j = l; j <= h-1; j++)

   mov esi, [ebp-12]    ; j
   mov edi, [ebp+8]     ; arr
   mov eax, [edi+esi*4] ; arr[j]
   cmp eax, [ebp-4]
   jg @out_if
   mov ecx, [ebp-8]     ; i
   inc ecx
   mov [ebp-8], ecx     ; i++

   lea eax, [edi+ecx*4] ; &arr[i]

   lea ebx, [edi+esi*4] ; &arr[j]

   push ebx
   push eax
   call swap            ; swap(&arr[i], &arr[j]);
@out_if:
  jmp @for_loop
@out_side_for:

   mov eax, [ebp+8]     ; arr
   mov ecx, [ebp-8]     ; i
   inc ecx              ; i + 1
   lea edi, [eax+ecx*4] ; &arr[i+1]
   mov ebx, [ebp+16]
   lea esi, [eax+ebx*4] ; &arr[h])
   mov [ebp-8], ecx
   
   push esi
   push edi
   call swap           ; swap(&arr[i+1], &arr[h]);

   pop edi
   pop esi
   pop edx
   pop ecx
   pop ebx
   pop eax

   mov eax, [ebp-8];
   add esp, 12
   pop ebp
   ret 12
partition ENDP

;==================================================================
quickSort PROC
   push ebp
   mov ebp, esp
   sub esp, 4
   push eax
   push ebx
   push ecx
   push edx
   push esi
   push edi
   
   mov eax, [ebp+8]  ; arr 
   mov esi, [ebp+12] ; l
   mov edi, [ebp+16] ; h

   cmp esi, edi
   jge @out_side_if

   push edi ; h
   push esi ; l
   push eax
   call partition

   mov edx, eax
   dec edx  ; p-1
   mov ebx, eax
   inc ebx  ; p+1

   mov eax, [ebp+8]; arr
   
   push edx ; p-1
   push esi ; l
   push eax ;arr 
   call quickSort ; quickSort(arr, l, p-1);

   push edi ; h
   push ebx ; p+1
   push eax ; arr
   call quickSort ; quickSort(arr, p+1, h);

@out_side_if:
   pop edi
   pop esi
   pop edx
   pop ecx
   pop ebx
   pop eax
   add esp, 4
   pop ebp
   ret 12
quickSort ENDP

;==================================================================
printArray PROC
    push ebp
    mov ebp, esp
    pushad
    push ebx
    push eax
    push esi
    mov esi, [ebp+8]
    .data
   szFmtLoc db '%d ', 0
   .code

    xor ebx, ebx
    while_loop: 
    cmp ebx, [ebp+12]
    jge quit_prg
    mov eax, [esi]
    invoke crt_printf, OFFSET szFmtLoc, eax
    add esi, 4
    inc ebx
    jmp while_loop
    quit_prg:
    .data
    szFmt db '%d ', 10 , 0; 10 is NEW LINE, aka: '\n' 
    .code
    mov eax, [esi]
    invoke crt_printf, OFFSET szFmt, eax
    pop esi
    pop eax
    pop ebx
    popad
    pop ebp
    ret 8
printArray ENDP

;==================================================================
main PROC
   push ebp
   mov ebp, esp
   sub esp, 34 ;Allocate memory

   push 11
   push offset array
   call printArray

   push 11
   push 0
   push offset array
   call quickSort
   
   push 11
   push offset array
   call printArray

   add esp, 34
   pop ebp
   ret
main ENDP
END main
