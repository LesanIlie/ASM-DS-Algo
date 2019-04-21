.386
.MODEL flat, stdcall
.STACK 4096

include msvcrt.inc
includelib msvcrt.lib

.data
ListNode STRUCT
    NodeData DWORD ?
    NextPtr  DWORD ?
ListNode ENDS

TotalNodeCount = 15
NULL = 0
Counter = 0

.data
LinkedList LABEL PTR ListNode

REPT TotalNodeCount
     Counter = Counter + 1
     ListNode  <Counter, ($ + Counter * SIZEOF ListNode)>
ENDM

ListNode <0,0>
.code
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
    while_loop:
    
    mov ebx, [esi+4] 
    cmp ebx, NULL
    je quit_prg
    mov eax, [esi]
    invoke crt_printf, OFFSET szFmtLoc, eax
    mov esi, [esi+4]
    jmp while_loop
    quit_prg:
   
    pop esi
    pop eax
    pop ebx
    popad
    pop ebp
    ret 4
printList ENDP

main PROC
   mov esi, OFFSET LinkedList
;NextNode:
   ;mov eax, [esi+4]
   ;cmp eax, NULL
   ;je quit
   ;.data
   ;szFmt db '%d ', 0
   .code
   ;mov eax, [esi]
   
   ;mov esi, [esi+4]
   ;jmp NextNode
   quit:
   push OFFSET LinkedList
   call printList
 
ret
main ENDP
END main