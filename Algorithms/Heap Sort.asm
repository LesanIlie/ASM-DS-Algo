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
maxHeapify PROC
    push ebp
    mov ebp, esp
    sub esp, 12
    
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov eax, [ebp+12];idx

    mov [ebp-4], eax; largest = idx

    shl eax, 1
    inc eax
    mov [ebp-8], eax    ; left = (idx << 1) + 1

    mov eax, [ebp+12]   ; idx
    inc eax
    shl eax, 1
    mov [ebp-12], eax   ; right = (idx + 1) << 1
    
;------------------------------------------------------
    mov eax, [ebp+8]
    mov ebx, [eax]      ; maxHeam->Size
    cmp [ebp-8], ebx
    jge out_side_first_if
    mov ebx, [eax+4]    ; maxHeap->array
    mov ecx, [ebp-8]    ; left
    mov edx, [ebp-4]    ; largest
    mov eax, [ebp+8]
    mov eax, [eax+4]
    mov esi, [eax+ecx*4]; maxHeap->array[left]
    mov edi, [eax+edx*4]; maxHeap->array[largest]
    cmp esi, edi
    jle out_side_first_if
    mov [ebp-4], ecx    ; largest = left
out_side_first_if:
;------------------------------------------------------
    mov eax, [ebp+8]
    mov ebx, [eax]      ; maxHeam->Size
    cmp [ebp-12], ebx
    jge out_side_second_if
    mov ebx, [eax+4]    ; maxHeap->array
    mov ecx, [ebp-12]   ; right
    mov edx, [ebp-4]    ; largest
    mov eax, [ebp+8]
    mov eax, [eax+4]
    mov esi, [eax+ecx*4]; maxHeap->array[rigth]
    mov edi, [eax+edx*4]; maxHeap->array[largest]
    cmp esi, edi
    jle out_side_second_if
    mov [ebp-4], ecx    ; largest = left
    
out_side_second_if:
;------------------------------------------------------
   mov edx, [ebp-4]; largest
   mov eax, [ebp+8]
   mov eax, [eax+4]; &maxHeap->array[xx..]

   cmp edx, [ebp+12]
   je @no_swap
   lea edi, [eax+edx*4]; maxHeap->array[largest]
   mov ecx, [ebp+12]   ;idx
   lea esi, [eax+ecx*4]; maxHeap->array[idx]

   push esi
   push edi
   call swap           ;swap(&maxHeap->array[largest], &maxHeap->array[idx]);
   
   mov edx, [ebp-4]
   mov eax, [ebp+8]
   push edx
   push eax
   call maxHeapify     ;maxHeapify(maxHeap, largest);
 @no_swap:
;------------------------------------------------------
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    add esp, 12
    pop ebp
    ret 8
maxHeapify ENDP

;==================================================================
createAndBuildHeap PROC
   push ebp
   mov ebp, esp
   sub esp, 8

   push eax
   push ebx
   push ecx
   push edx
   push esi
   push edi

   push 8
   call crt_malloc ; struct MaxHeap *maxHeap = (struct MaxHeap*)malloc(sizeof(struct MaxHeap));
   add esp, 4

   mov [ebp-4], eax
   mov ebx, [ebp+12]    ; size
   mov ecx, [ebp+8]     ; array
   mov [eax], ebx       ; maxHeap->size = size;
   mov [eax+4], ecx     ; maxHeap->array = array;
   
   mov eax, [ebp+12]
   sub eax, 2
   cdq
   mov ecx, 2
   idiv  ecx
   mov [ebp-8], eax; i = (maxHeap->size - 2) / 2

 jmp @first_for_jmp
@for_loop:
   mov eax, [ebp-8]
   dec eax
   mov [ebp-8], eax
@first_for_jmp:
   
  cmp eax, 0 ; for (i = (maxHeap->size - 2) / 2; i >= 0; --i)
  jl @out_side_for_loop

  mov ecx, [ebp-4]

  push eax
  push ecx
  call maxHeapify ; maxHeapify(maxHeap, i);
  jmp @for_loop
@out_side_for_loop:

   pop edi
   pop esi
   pop edx
   pop ecx
   pop ebx
   pop eax

   mov eax, [ebp-4]
   add esp, 8
   pop ebp
   ret 8
createAndBuildHeap ENDP
;==================================================================
heapSort PROC 
  push ebp
  mov ebp, esp
  sub esp, 4

  push eax
  push ebx
  push ecx
  push edx
  push esi
  push edi

  mov eax, [ebp+8]
  mov ecx, [ebp+12]

  push ecx
  push eax
  call createAndBuildHeap
  mov [ebp-4], eax ; struct MaxHeap *maxHeap = createAndBuildHeap(array, size);

  @while_loop:
  mov eax, [ebp-4]
  mov ebx, [eax]
  cmp ebx, 1
  jle @out_side_while_loop ; while (maxHeap->size > 1)
  ;{
   mov ebx, [eax+4]
   lea ecx, [ebx]   ; &maxHeap->array[0]
   
   mov ebx, [eax+4] ; &maxHeap->array
   mov edx, [eax]
   dec edx
   lea esi, [ebx+edx*4] ; &maxHeap->array[maxHeap->size-1

   push esi ;&maxHeap->array[maxHeap->size-1
   push ecx ;maxHeap->array[0]
   call swap

   mov [eax], edx ; --maxHeap->size;

   mov eax, [ebp-4]
   xor ecx, ecx
 
   push ecx
   push eax
   call maxHeapify
  ;}
  jmp @while_loop
@out_side_while_loop:

  pop edi
  pop esi
  pop edx
  pop ecx
  pop ebx
  pop eax

  add esp, 4
  pop ebp
  ret 8
heapSort ENDP

;==================================================================
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
main PROC
   push ebp
   mov ebp, esp
   sub esp, 34 ;Allocate memory

   ;push 10
   ;push offset array
   ;call printList

   push 11
   push offset array
   call heapSort;schimba
   mov eax, eax;In eax is the returned index

   push 11
   push offset array
   call printList

   add esp, 34
   pop ebp
   ret
main ENDP
END main
