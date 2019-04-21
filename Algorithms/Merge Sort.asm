.386
.MODEL flat, stdcall
.STACK 8096

include msvcrt.inc
includelib msvcrt.lib

.data

array DWORD 13h, 11h, 15h, 9h, 23h, 1h, 43h, 45h, 23h, 23h, 12h, 00h
L     DWORD 00h,00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h  ;100 elements and initialize all with zero
R     DWORD 00h,00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
.code
;==================================================================
;==================================================================
merge PROC
   push ebp
   mov ebp, esp
   sub esp, 20; 4 * 5 = 20 bytes
   push eax
   push ebx
   push ecx
   push edx
   push esi
   push edi

   mov eax, [ebp+16]; m
   sub eax, [ebp+12]; m - l
   inc eax          ; m - l + 1
   mov [ebp-4], eax ; n1 = m - l + 1

   mov ebx, [ebp+20]; r 
   sub ebx, [ebp+16]; r - m 
   mov [ebp-8], ebx ; n2 = r - m

   ;for (i = 0; i < n1; i++)
   ;    L[i] = arr[l+i];
   xor ecx, ecx
   mov[ebp-12], ecx; i = 0
   jmp @first_for_jmp
@first_for_loop:
   mov ecx, [ebp-12]
   inc ecx
   mov [ebp-12], ecx; i++; 
@first_for_jmp:
   cmp ecx, [ebp-4]
   jge @out_side_loop;for (i = 0; i < n1; i++)
   mov ebx, [ebp+12]; l
   add ebx, ecx
   mov eax, [ebp+8]
   mov esi, [eax+ebx*4]; arr[l]
   mov [L+ecx*4], esi; L[i] = arr[l+i]

   jmp @first_for_loop
@out_side_loop:
;============================================================================
 ; for (j = 0; j < n2; j++)
 ;      R[j] = arr[m+1+j];
   xor ecx, ecx
   mov[ebp-16], ecx; j = 0
   jmp @second_for_jmp
@second_for_loop:
   mov ecx, [ebp-16]
   inc ecx
   mov [ebp-16], ecx; j++; 
@second_for_jmp:
   cmp ecx, [ebp-8]
   jge @out_side_second_loop;for (j = 0; j < n2; j++)
   mov ebx, [ebp+16]; m
   add ebx, ecx
   inc ebx
   mov eax, [ebp+8]
   mov esi, [eax+ebx*4]; arr[l]
   mov [R+ecx*4], esi; L[i] = arr[l+i]

   jmp @second_for_loop
@out_side_second_loop:
;============================================================================
  xor ecx, ecx
  mov [ebp-12], ecx; i = 0
  mov [ebp-16], ecx; j = 0
  mov ecx, [ebp+12]; l
  mov [ebp-20], ecx; k = l

  ; while (i < n1 && j < n2)
@big_while_loop:
  mov ecx, [ebp-12]; i
  cmp ecx, [ebp-4]; i < n1
  jge @out_side_while_loop
  mov ebx, [ebp-16]; j
  cmp ebx, [ebp-8]; j < n2
  jge @out_side_while_loop
  ;--------------------------------------------------------------------------
  ;if (L[i] <= R[j])
  ;   {
  ;      arr[k] = L[i];
  ;      i++;
  ;   }
  mov eax, [L+ecx*4]; L[i]
  mov esi, [R+ebx*4]; R[j]
  mov edi, [ebp-20]; k
  cmp eax, esi
  jg @else
  mov esi, [ebp+8]
  mov [esi+edi*4], eax
  mov ecx, [ebp-12]
  inc ecx
  mov [ebp-12], ecx; i++
  jmp @out_else
@else:
 ;else 
 ;{
 ;   arr[k] = R[j];
 ;   j++;
 ;}
  mov eax, [ebp+8]
  mov [eax+edi*4], esi
  mov ecx, [ebp-16]
  inc ecx
  mov [ebp-16], ecx; j++
@out_else:
  ;k++
  mov ecx, [ebp-20]
  inc ecx
  mov [ebp-20], ecx; k++
  jmp @big_while_loop
  ;--------------------------------------------------------------------------
  
@out_side_while_loop:
;============================================================================
;while (i < n1)
;{
;  arr[k] = L[i];
;  i++;
;  k++;
;}
@L_last_loop:
  mov ecx, [ebp-12] ; i
  cmp ecx, [ebp-4]  ; n1
  jge @out_L_last_loop
  mov eax, [ebp-20] ; k
  mov ebx, [ebp-12] ; i
  mov esi, [L+ebx*4]
  mov edi, [ebp+8]
  mov [edi+eax*4], esi; arr[k] = L[i];

  mov ecx, [ebp-12]
  inc ecx
  mov [ebp-12], ecx; i++

  mov ecx, [ebp-20]
  inc ecx
  mov [ebp-20], ecx; k++

  jmp @L_last_loop
 @out_L_last_loop:
;--------------------------------------------------------------------------

;============================================================================
;while (i < n2)
;{
;  arr[k] = R[j];
;  j++;
;  k++;
;}
@R_last_loop:
  mov ecx, [ebp-16] ; j
  cmp ecx, [ebp-8]  ; n2
  jge @out_R_last_loop
  mov eax, [ebp-20] ; k
  mov ebx, [ebp-16] ; j
  mov esi, [R+ebx*4]
  mov edi, [ebp+8] 
  mov [edi+eax*4], esi; arr[k] = R[j];

  mov ecx, [ebp-16]
  inc ecx
  mov [ebp-16], ecx; j++

  mov ecx, [ebp-20]
  inc ecx
  mov [ebp-20], ecx; k++

  jmp @R_last_loop
 @out_R_last_loop:
;--------------------------------------------------------------------------
   pop edi
   pop esi
   pop edx
   pop ecx
   pop ebx
   pop eax

   add esp, 20;
   pop ebp
   ret 16
merge ENDP
;==================================================================
;==================================================================
mergeSort PROC
   push ebp
   mov ebp, esp
   sub esp, 4
   
   push eax
   push ebx
   push ecx
   push edx
   push esi
   push edi 

   mov eax, [ebp+12]
   mov ebx, [ebp+16]
   cmp eax, ebx
   jge @out_side_loop
   add eax, ebx
   cdq
   sar eax, 1
   mov [ebp-4], eax
   mov ebx, eax

   mov esi, [ebp+12]; l
   push eax         ; m
   push esi         ; l
   mov eax, [ebp+8]
   push eax
   mov edi, offset mergeSort
   call edi ;mergeSort(arr, l, m);


   mov esi, [ebp+16]; r
   push esi         ; r
   inc ebx          ; m+1
   push ebx         ; m+1
   mov eax, [ebp+8]
   push eax
   mov edi, offset mergeSort
   call edi ; mergeSort(arr, m+1, r);

   mov eax, [ebp+12]; l
   mov ebx, [ebp+16]; r
   mov ecx, [ebp-4] ; m

   push ebx
   push ecx
   push eax
   mov eax, [ebp+8]
   push eax
   mov edi, offset merge
   call edi ; merge(arr, l, m, r);

@out_side_loop:
   pop edi
   pop esi
   pop edx
   pop ecx
   pop ebx
   pop eax

   add esp, 4
   pop ebp
   ret 12
mergeSort ENDP

;Functie care printeza o lista inlantuita
printList PROC
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
printList ENDP

;==================================================================
;==================================================================
main PROC
   push ebp
   mov ebp, esp
   sub esp, 200 ;Allocate memory

   push 10
   push offset array
   call printList

   push 10
   push 0
   push offset array
   call mergeSort;schimba
   mov eax, eax;In eax is the returned index

   push 10
   push offset array
   call printList


   add esp, 200
   pop ebp
   ret
main ENDP
END main
