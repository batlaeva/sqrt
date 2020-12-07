%macro _pushd 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro _popd 0
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro

%macro _print 2
    _pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    _popd
%endmacro

%macro _dprint 1
    _pushd
    mov ecx, 10
    mov bx, 0 ; 2 Bytes MAX, Count Numbers
    mov eax, %1
    
%%_divide:
    mov edx, 0
    div ecx
    push dx
    inc bx
    test eax, eax
    jnz %%_divide
    
%%_digit:
    pop ax
    add ax, '0'
    mov [symbol], ax
    _print 1, symbol
    dec bx
    cmp bx, 0
    jg %%_digit
    _popd
%endmacro

%macro _calcX2 2
    push ebx
    push ecx
    push edx
    mov edx, 0
    mov ecx, %2
    push ecx
    mov eax, %1
    div ecx
    pop edx
    add eax, edx
    mov edx, 0
    mov ecx, 2
    div ecx
    pop edx
    pop ecx
    pop ebx
%endmacro

%macro _sqrt 1
    mov eax, %1
    mov ecx, 2
    _calcX2 %1, eax
    div ecx ; Result in EAX, friction part in EDX
    mov [x1], eax

    _calcX2 %1, eax
    mov[x2], eax
_while:
    mov eax, [x1]
    mov ecx, [x2]
    sub eax, ecx
    cmp eax, 1
    jl _end
    
    mov eax, [x2]
    mov [x1], eax
    _calcX2 %1, [x1]
    mov [x2], eax
    jmp _while
%endmacro

section .text
global _start

_start:
    _sqrt [num]
    
_end:    
    _dprint [x2]
    _print nl, n
    
    mov     eax, 1
    int     0x80

section.data
    num DD 121
    n DB 0xA, 0xD
    nl EQU $ - n
    
section .bss
    x1 resd 1 ; Reserve DWORD (1 Count)
    x2 resd 1
    symbol resb 1