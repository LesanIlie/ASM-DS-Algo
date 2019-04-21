.386
.MODEL flat,stdcall
.STACK 4096

include     msvcrt.inc
includelib  msvcrt.lib

.data
ListNode STRUCT
    NodeData DWORD ?
    NextPtr DWORD ?
ListNode ENDS

TotalNodeCount = 15
NULL = 0
Counter  = 0

.data
LinkedList LABEL PTR ListNode
REPT TotalNodeCount
     Counter = Counter + 1
     ;ListNode <Counter, ( $ +  SIZEOF ListNode)>
     ListNode <Counter, ( $ + Counter * SIZEOF ListNode)>
ENDM
ListNode <0,0>
.code
main  PROC 
    mov esi, OFFSET LinkedList
NextNode:
    mov eax, [esi+4]
    cmp eax, NULL
    je quit
    
    .data 
    szFmt db '%d ', 0
    .code
    mov eax, [esi]
   invoke crt_printf, OFFSET szFmt, eax

    mov esi, [esi+4]
   jmp NextNode
    
quit:
ret
main ENDP
END main