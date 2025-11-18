; ================================================================
; CALCULADORA PROGRAMADOR DIDÁTICA
; Implementação em Assembly x86-64
; ================================================================
; Funcionalidades:
; 1. Conversão de base 10 para base 2, 8, 16 e BCD
; 2. Conversão de real decimal para float IEEE 754
; ================================================================

section .data
    ; Mensagens do menu
    menu_titulo      db 10, "========================================", 10
                     db "  CALCULADORA PROGRAMADOR DIDATICA", 10
                     db "========================================", 10
                     db "1 - Converter decimal para binario (base 2)", 10
                     db "2 - Converter decimal para octal (base 8)", 10
                     db "3 - Converter decimal para hexadecimal (base 16)", 10
                     db "4 - Converter decimal para BCD", 10
                     db "5 - Converter real para float IEEE 754", 10
                     db "0 - Sair", 10
                     db "========================================", 10
                     db "Escolha uma opcao: ", 0
    
    msg_entrada_decimal db 10, "Digite um numero decimal: ", 0
    msg_entrada_real    db 10, "Digite um numero real (ex: 12.5): ", 0
    msg_erro            db 10, "Erro: Entrada invalida!", 10, 0
    msg_resultado       db 10, "RESULTADO FINAL: ", 0
    msg_saindo          db 10, "Saindo...", 10, 0
    msg_base2           db 10, "=== CONVERSAO PARA BASE 2 (BINARIO) ===", 10, 0
    msg_base8           db 10, "=== CONVERSAO PARA BASE 8 (OCTAL) ===", 10, 0
    msg_base16          db 10, "=== CONVERSAO PARA BASE 16 (HEXADECIMAL) ===", 10, 0
    msg_bcd             db 10, "=== CONVERSAO PARA BCD ===", 10, 0
    msg_float           db 10, "=== CONVERSAO PARA FLOAT IEEE 754 ===", 10, 0
    
    msg_passos          db 10, "--- PASSOS DA CONVERSAO ---", 10, 0
    msg_divisao         db "Passo: ", 0
    msg_por             db " / ", 0
    msg_resto           db " = ", 0
    msg_com_resto       db " (resto: ", 0
    msg_fecha_paren     db ")", 10, 0
    msg_novo_quociente  db "Novo quociente: ", 0
    
    ; Strings para formatação
    str_binario         db " em binario: ", 0
    str_octal           db " em octal: ", 0
    str_hexadecimal     db " em hexadecimal: ", 0
    str_bcd             db " em BCD: ", 0
    str_igual           db " = ", 0
    str_espaco          db " ", 0
    
    ; Formatação float
    msg_sinal           db 10, "Bit de Sinal (1 bit): ", 0
    msg_expoente        db 10, "Expoente (8 bits): ", 0
    msg_expoente_vies   db "  (valor com viés 127): ", 0
    msg_expoente_real   db "  (valor real do expoente): ", 0
    msg_fracao          db 10, "Fracao/Mantissa (23 bits): ", 0
    msg_numero_original  db 10, "Numero original: ", 0
    msg_binario_completo db 10, "Representacao binaria completa (32 bits): ", 0
    msg_hex_completo     db 10, "Representacao hexadecimal: 0x", 0
    
    ; Buffer para entrada
    buffer              times 256 db 0
    buffer_numero       times 32 db 0
    buffer_hex          times 16 db 0
    
    ; Formatação
    newline             db 10, 0

section .bss
    numero              resd 1
    numero_real         resd 1
    opcao               resb 2
    pilha_restos        resq 64    ; Pilha para armazenar restos

section .text
    global _start

_start:
    ; Loop principal do programa
menu_loop:
    ; Exibir menu
    mov rdi, menu_titulo
    call print_string
    
    ; Ler opção
    mov rdi, opcao
    mov rsi, 2
    call read_input
    
    ; Processar opção
    mov al, [opcao]
    cmp al, '1'
    je converter_base2
    cmp al, '2'
    je converter_base8
    cmp al, '3'
    je converter_base16
    cmp al, '4'
    je converter_bcd
    cmp al, '5'
    je converter_float
    cmp al, '0'
    je sair
    ; Opção inválida, voltar ao menu
    jmp menu_loop

; ================================================================
; Conversão para Base 2 (Binário)
; ================================================================
converter_base2:
    mov rdi, msg_base2
    call print_string
    
    ; Ler número decimal
    call ler_decimal
    cmp rax, -1
    je menu_loop
    
    mov [numero], eax
    
    ; Exibir passos
    mov rdi, msg_passos
    call print_string
    
    ; Converter e mostrar passos
    mov edi, [numero]
    mov esi, 2
    call converter_com_passos
    
    mov rdi, newline
    call print_string
    
    ; Converter e exibir resultado
    mov edi, [numero]
    mov esi, 2
    call converter_base
    
    mov rdi, newline
    call print_string
    call print_string
    
    jmp menu_loop

; ================================================================
; Conversão para Base 8 (Octal)
; ================================================================
converter_base8:
    mov rdi, msg_base8
    call print_string
    
    call ler_decimal
    cmp rax, -1
    je menu_loop
    
    mov [numero], eax
    
    mov rdi, msg_passos
    call print_string
    
    mov edi, [numero]
    mov esi, 8
    call converter_com_passos
    
    mov rdi, newline
    call print_string
    
    mov edi, [numero]
    mov esi, 8
    call converter_base
    
    mov rdi, newline
    call print_string
    call print_string
    
    jmp menu_loop

; ================================================================
; Conversão para Base 16 (Hexadecimal)
; ================================================================
converter_base16:
    mov rdi, msg_base16
    call print_string
    
    call ler_decimal
    cmp rax, -1
    je menu_loop
    
    mov [numero], eax
    
    mov rdi, msg_passos
    call print_string
    
    mov edi, [numero]
    mov esi, 16
    call converter_com_passos
    
    mov rdi, newline
    call print_string
    
    mov edi, [numero]
    mov esi, 16
    call converter_base
    
    mov rdi, newline
    call print_string
    call print_string
    
    jmp menu_loop

; ================================================================
; Conversão para BCD
; ================================================================
converter_bcd:
    mov rdi, msg_bcd
    call print_string
    
    call ler_decimal
    cmp rax, -1
    je menu_loop
    
    mov [numero], eax
    
    mov rdi, msg_passos
    call print_string
    
    ; Mostrar número original
    mov rdi, msg_numero_original
    call print_string
    mov edi, [numero]
    call print_decimal
    mov rdi, newline
    call print_string
    
    ; Converter para BCD
    mov edi, [numero]
    call converter_para_bcd
    
    mov rdi, newline
    call print_string
    call print_string
    
    jmp menu_loop

; ================================================================
; Conversão para Float IEEE 754
; ================================================================
converter_float:
    mov rdi, msg_float
    call print_string
    
    ; Ler número real
    mov rdi, msg_entrada_real
    call print_string
    
    mov rdi, buffer
    mov rsi, 256
    call read_input
    
    ; Converter string para float (aceita negativos e decimais simples)
    mov rdi, buffer
    call string_to_float_simple
    cmp rax, -1  ; Valor de erro (consistente com string_to_int)
    je erro_entrada
    
    ; Converter para float
    cvtsi2ss xmm0, rax
    movss [numero_real], xmm0
    mov edi, [numero_real]
    
    ; Exibir análise do float
    mov rdi, msg_numero_original
    call print_string
    mov rdi, buffer
    call print_string
    mov rdi, newline
    call print_string
    
    ; Analisar bits do float
    mov edi, [numero_real]
    call analisar_float
    
    mov rdi, newline
    call print_string
    call print_string
    
    jmp menu_loop

erro_entrada:
    mov rdi, msg_erro
    call print_string
    jmp menu_loop

; ================================================================
; Função para ler número decimal
; ================================================================
ler_decimal:
    push rbp
    mov rbp, rsp
    
    mov rdi, msg_entrada_decimal
    call print_string
    
    mov rdi, buffer
    mov rsi, 256
    call read_input
    
    ; Converter string para número
    mov rdi, buffer
    call string_to_int
    
    leave
    ret

; ================================================================
; Função: Converter número para base específica com passos
; Entrada: EDI = número, ESI = base
; ================================================================
converter_com_passos:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    mov ebx, edi      ; Número original
    mov r12d, esi     ; Base
    mov r13d, 0       ; Contador de passos
    
    ; Mostrar número original
    mov rdi, msg_numero_original
    push rbx          ; Preservar número
    push r12          ; Preservar
    push r13          ; Preservar
    call print_string
    pop r13           ; Restaurar
    pop r12           ; Restaurar
    pop rbx           ; Restaurar número
    
    mov edi, ebx
    push rbx          ; Preservar
    push r12          ; Preservar
    push r13          ; Preservar
    call print_decimal
    pop r13           ; Restaurar
    pop r12           ; Restaurar
    pop rbx           ; Restaurar
    
    mov rdi, newline
    push rbx          ; Preservar
    push r12          ; Preservar
    push r13          ; Preservar
    call print_string
    pop r13           ; Restaurar
    pop r12           ; Restaurar
    pop rbx           ; Restaurar
    
    ; Loop de conversão com passos
converter_loop_passos:
    ; Verificar se base é zero (proteção)
    cmp r12d, 0
    je fim_converter_passos  ; Se base for zero, sair
    
    mov eax, ebx
    mov edx, 0
    mov ecx, r12d
    div ecx          ; EAX = quociente, EDX = resto
    
    ; Exibir passo
    ; Após div: EAX = quociente, EDX = resto
    ; Usar r8 e r9 como temporários (não estão na pilha)
    mov r8, rax       ; R8 = quociente
    mov r9, rdx       ; R9 = resto
    
    ; Preservar tudo antes de chamadas
    push rax
    push rdx
    push rbx
    push r12
    push r13
    
    mov rdi, msg_divisao
    call print_string
    mov edi, ebx
    call print_decimal
    mov rdi, msg_por
    call print_string
    mov edi, r12d
    call print_decimal
    mov rdi, msg_resto
    call print_string
    mov edi, r8d      ; Usar R8 (quociente salvo)
    call print_decimal
    mov rdi, msg_com_resto
    call print_string
    mov edi, r9d      ; Usar R9 (resto salvo)
    call print_decimal
    mov rdi, msg_fecha_paren
    call print_string
    
    ; Restaurar registradores
    pop r13
    pop r12
    pop rbx
    pop rdx
    pop rax
    
    ; Restaurar valores de r8/r9
    mov rax, r8       ; Restaurar quociente
    mov rdx, r9       ; Restaurar resto
    
    ; Empilhar resto
    push rdx
    inc r13d
    
    ; Atualizar número
    mov ebx, eax
    
    ; Continuar enquanto quociente > 0
    cmp ebx, 0
    jg converter_loop_passos
    
    ; Mostrar resultado
    mov rdi, msg_resultado
    call print_string  ; print_string preserva seus próprios registradores
    
    ; Desempilhar e exibir dígitos
    ; Usar r8 como contador temporário (não está na pilha)
    mov r8d, r13d     ; Copiar contador para r8
    cmp r8d, 0
    je fim_converter_passos
    
mostrar_resultado:
    pop rdx           ; Desempilhar resto (empilhado no loop de conversão)
    mov edi, edx      ; Salvar edx em edi antes das chamadas
    
    ; Para hexadecimal, usar letras
    cmp r12d, 16
    jne nao_hex
    
    ; Para hexadecimal, converter para letras
    cmp edx, 9
    jle digito_numero
    add edx, 7        ; Ajustar para A-F
digito_numero:
    add edx, '0'
    mov [buffer_numero], dl
    mov byte [buffer_numero + 1], 0
    mov rdi, buffer_numero
    call print_string  ; print_string preserva seus próprios registradores
    
proximo_digito:
    dec r8d           ; Decrementar contador (r8 não precisa ser preservado)
    cmp r8d, 0
    jg mostrar_resultado
    jmp fim_converter_passos  ; Sair do loop quando contador chegar a 0
    
nao_hex:
    call print_decimal  ; print_decimal preserva seus próprios registradores
    jmp proximo_digito  ; Continuar após print_decimal
    
fim_converter_passos:
    
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    leave
    ret

; ================================================================
; Função: Converter número para base específica
; Entrada: EDI = número, ESI = base
; ================================================================
converter_base:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    mov ebx, edi      ; Número
    mov r12d, esi     ; Base
    mov r15d, 0       ; Contador de dígitos
    
    ; Determinar mensagem de resultado
    cmp r12d, 2
    je msg_bin
    cmp r12d, 8
    je msg_oct
    cmp r12d, 16
    je msg_hex
    jmp converter_loop
    
msg_bin:
    mov rdi, msg_numero_original
    call print_string
    mov edi, ebx
    call print_decimal
    mov rdi, str_binario
    call print_string
    jmp converter_loop
    
msg_oct:
    mov rdi, msg_numero_original
    call print_string
    mov edi, ebx
    call print_decimal
    mov rdi, str_octal
    call print_string
    jmp converter_loop
    
msg_hex:
    mov rdi, msg_numero_original
    call print_string
    mov edi, ebx
    call print_decimal
    mov rdi, str_hexadecimal
    call print_string
    
    ; Converter e empilhar (contando dígitos ao mesmo tempo)
    mov r15d, 0      ; Contador de dígitos
    
    ; Verificar se base é zero (proteção)
    cmp r12d, 0
    je fim_exibir  ; Se base for zero, sair
    
converter_loop:
    mov eax, ebx
    mov edx, 0
    mov ecx, r12d
    div ecx
    push rdx
    inc r15d          ; Incrementar contador
    mov ebx, eax
    cmp ebx, 0
    jg converter_loop
    
    ; Exibir resultado usando contador r15d
    ; Usar r8 como contador temporário (não está na pilha)
    mov r8d, r15d     ; Copiar contador para r8
    cmp r8d, 0
    je fim_exibir
    
exibir_resultado:
    pop rdx           ; Desempilhar resto (empilhado no loop de conversão)
    mov edi, edx      ; Salvar edx em edi antes das chamadas
    
    ; Para hexadecimal
    cmp r12d, 16
    jne nao_hex_resultado
    cmp edx, 9
    jle digito_num_resultado
    add edx, 7
digito_num_resultado:
    add edx, '0'
    mov [buffer_numero], dl
    mov byte [buffer_numero + 1], 0
    mov rdi, buffer_numero
    call print_string  ; print_string preserva seus próprios registradores
    jmp proximo_resultado
nao_hex_resultado:
    call print_decimal ; print_decimal preserva seus próprios registradores
proximo_resultado:
    dec r8d           ; Decrementar contador (r8 não precisa ser preservado)
    cmp r8d, 0
    jg exibir_resultado

fim_exibir:
    
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    leave
    ret

; ================================================================
; Função: Converter para BCD
; Entrada: EDI = número decimal
; ================================================================
converter_para_bcd:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    mov ebx, edi
    mov r12, rsp      ; Salvar posição da pilha
    mov r13d, 0       ; Contador de dígitos
    
    ; Separar dígitos e converter cada um para BCD
    mov eax, ebx
    mov ecx, 10
    
separar_digitos:
    cmp eax, 0
    je fim_separar
    
    ; Verificar se divisor é zero (proteção)
    cmp ecx, 0
    je fim_separar  ; Se divisor for zero, sair
    
    mov edx, 0
    div ecx           ; EAX = quociente, EDX = resto (dígito)
    push rdx          ; Empilhar dígito
    inc r13d
    cmp eax, 0
    jg separar_digitos
fim_separar:
    
    ; Exibir resultado BCD
    mov rdi, msg_resultado
    call print_string
    
    mov r14d, r13d     ; Usar r14 como contador (preservar r13 para pop)
    cmp r14d, 0
    je fim_bcd
mostrar_bcd:
    pop rdx
    push r14          ; Preservar contador de dígitos
    mov edi, edx
    
    ; Mostrar dígito decimal
    push r12          ; Preservar r12
    push r13          ; Preservar r13
    push r14          ; Preservar r14
    call print_decimal
    pop r14           ; Restaurar r14
    pop r13           ; Restaurar r13
    pop r12           ; Restaurar r12
    
    mov rdi, str_igual
    push r12          ; Preservar
    push r13          ; Preservar
    push r14          ; Preservar
    call print_string
    pop r14           ; Restaurar
    pop r13           ; Restaurar
    pop r12           ; Restaurar
    
    ; Converter para BCD (4 bits por dígito)
    ; Preservar edx que contém o dígito
    push rdx          ; Salvar dígito na pilha
    
    ; Converter dígito para binário BCD (4 bits)
    mov eax, edx       ; EAX = dígito (0-9)
    mov r15d, 8        ; Máscara inicial (bit 3 = 8)
    
    ; Mostrar 4 bits
    mov ecx, 4         ; Contador de bits
loop_bcd_bits:
    test eax, r15d     ; Testar bit
    jz bit_zero_bcd
    mov byte [buffer_numero], '1'
    jmp print_bit_bcd
bit_zero_bcd:
    mov byte [buffer_numero], '0'
print_bit_bcd:
    mov byte [buffer_numero + 1], 0
    push rax          ; Preservar valor do dígito
    push rcx          ; Preservar contador de bits
    push r15          ; Preservar máscara
    push r14          ; Preservar contador de dígitos
    mov rdi, buffer_numero
    call print_string
    pop r14           ; Restaurar contador de dígitos
    pop r15           ; Restaurar máscara
    pop rcx           ; Restaurar contador de bits
    pop rax           ; Restaurar valor do dígito
    
    shr r15d, 1       ; Shift da máscara
    dec ecx
    cmp ecx, 0
    jg loop_bcd_bits
    
    ; Restaurar contador de dígitos (que estava na pilha)
    pop rdx           ; Remover dígito da pilha
    pop r14           ; Restaurar contador de dígitos
    dec r14d
    
    ; Espaço entre dígitos BCD (exceto no último)
    cmp r14d, 0
    jle sem_espaco_bcd
    push r14          ; Preservar
    mov rdi, str_espaco
    call print_string
    pop r14           ; Restaurar
sem_espaco_bcd:
    
    cmp r14d, 0
    jg mostrar_bcd
    
fim_bcd:
    
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    leave
    ret

; ================================================================
; Função: Analisar float IEEE 754
; Entrada: EDI = valor float (32 bits)
; ================================================================
analisar_float:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    
    mov ebx, edi      ; Valor float completo
    
    ; Mostrar representação binária completa
    mov rdi, msg_binario_completo
    call print_string
    mov edi, ebx
    call print_binario_32bits
    mov rdi, newline
    call print_string
    
    ; Mostrar representação hexadecimal
    mov rdi, msg_hex_completo
    call print_string
    mov edi, ebx
    call print_hexadecimal
    mov rdi, newline
    call print_string
    
    ; Extrair bit de sinal (bit 31)
    mov eax, ebx
    shr eax, 31
    mov rdi, msg_sinal
    call print_string
    mov edi, eax
    call print_decimal
    mov rdi, newline
    call print_string
    
    ; Extrair expoente (bits 30-23)
    mov eax, ebx
    shr eax, 23
    and eax, 0xFF
    push rax          ; Salvar expoente com viés
    
    mov rdi, msg_expoente
    call print_string
    
    ; Restaurar expoente para exibir
    pop rax
    push rax          ; Preservar para cálculos
    mov edi, eax
    push rax          ; Preservar novamente
    call print_binario_8bits
    pop rax           ; Restaurar expoente
    
    mov rdi, msg_expoente_vies
    call print_string
    mov edi, eax
    push rax          ; Preservar
    call print_decimal
    pop rax           ; Restaurar
    
    ; Calcular expoente real (expoente - 127)
    sub eax, 127
    mov rdi, msg_expoente_real
    push rax          ; Preservar resultado
    call print_string
    pop rax           ; Restaurar resultado
    mov edi, eax
    call print_decimal
    mov rdi, newline
    call print_string
    
    ; Extrair fração/mantissa (bits 22-0)
    mov eax, ebx
    and eax, 0x7FFFFF
    mov rdi, msg_fracao
    call print_string
    mov edi, eax
    call print_binario_23bits
    mov rdi, newline
    call print_string
    
    pop r12
    pop rbx
    leave
    ret

; ================================================================
; Função: Imprimir 32 bits binários
; Entrada: EDI = valor
; ================================================================
print_binario_32bits:
    push rbp
    mov rbp, rsp
    push rbx
    
    mov ebx, edi
    mov ecx, 32
    mov edx, 0x80000000  ; Bit mais significativo (bit 31)
    
loop_32bits:
    test ebx, edx
    jz zero_32
    mov byte [buffer_numero], '1'
    jmp print_32
zero_32:
    mov byte [buffer_numero], '0'
print_32:
    mov byte [buffer_numero + 1], 0
    mov rdi, buffer_numero
    call print_string
    shr edx, 1
    loop loop_32bits
    
    pop rbx
    leave
    ret

; ================================================================
; Função: Imprimir 8 bits binários
; Entrada: EDI = valor
; ================================================================
print_binario_8bits:
    push rbp
    mov rbp, rsp
    push rbx
    
    mov ebx, edi
    mov ecx, 8
    mov edx, 128      ; Bit mais significativo
    
loop_8bits:
    test ebx, edx
    jz zero_8
    mov byte [buffer_numero], '1'
    jmp print_8
zero_8:
    mov byte [buffer_numero], '0'
print_8:
    mov byte [buffer_numero + 1], 0
    mov rdi, buffer_numero
    call print_string
    shr edx, 1
    loop loop_8bits
    
    pop rbx
    leave
    ret

; ================================================================
; Função: Imprimir 23 bits binários
; Entrada: EDI = valor
; ================================================================
print_binario_23bits:
    push rbp
    mov rbp, rsp
    push rbx
    
    mov ebx, edi
    mov ecx, 23
    mov edx, 0x400000  ; Bit mais significativo (bit 22) = 2^22
    
loop_23bits:
    test ebx, edx
    jz zero_23
    mov byte [buffer_numero], '1'
    jmp print_23
zero_23:
    mov byte [buffer_numero], '0'
print_23:
    mov byte [buffer_numero + 1], 0
    mov rdi, buffer_numero
    call print_string
    shr edx, 1
    loop loop_23bits
    
    pop rbx
    leave
    ret

; ================================================================
; Função: Imprimir hexadecimal
; Entrada: EDI = valor (32 bits)
; ================================================================
print_hexadecimal:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    
    mov ebx, edi
    mov ecx, 8        ; 8 dígitos hexadecimais para 32 bits
    
loop_hex:
    mov eax, ebx
    shr eax, 28       ; Pegar 4 bits mais significativos
    and eax, 0xF
    
    ; Converter para caractere hexadecimal
    cmp eax, 9
    jle hex_numero
    add eax, 'A' - 10
    jmp hex_print
hex_numero:
    add eax, '0'
hex_print:
    mov [buffer_numero], al
    mov byte [buffer_numero + 1], 0
    push rcx          ; Preservar contador
    push rbx          ; Preservar valor
    mov rdi, buffer_numero
    call print_string
    pop rbx           ; Restaurar valor
    pop rcx           ; Restaurar contador
    
    shl ebx, 4        ; Shift left 4 bits
    dec ecx
    cmp ecx, 0
    jg loop_hex
    
    pop rcx
    pop rbx
    leave
    ret

; ================================================================
; Função: Converter string para float simples (aceita negativos e decimais)
; Entrada: RDI = string
; Saída: RAX = número inteiro (converte parte inteira se decimal)
;        Retorna -1 se erro (consistente com string_to_int)
; ================================================================
string_to_float_simple:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    
    mov rbx, rdi
    xor rax, rax
    xor rcx, rcx
    mov r9, 10         ; Base
    
    ; Pular espaços
skip_spaces_float:
    cmp byte [rbx], ' '
    jne check_sign_float
    inc rbx
    jmp skip_spaces_float
    
    ; Verificar sinal negativo
check_sign_float:
    cmp byte [rbx], '-'
    jne loop_convert_float
    mov cl, 1
    inc rbx
    
loop_convert_float:
    movzx r8, byte [rbx]
    cmp r8, 0
    je fim_convert_float
    cmp r8, 10
    je fim_convert_float
    cmp r8, 13
    je fim_convert_float
    cmp r8, '.'
    je fim_convert_float    ; Aceita ponto mas para aqui (só parte inteira)
    cmp r8, ','
    je fim_convert_float    ; Aceita vírgula mas para aqui
    cmp r8, '0'
    jb erro_convert_float
    cmp r8, '9'
    ja erro_convert_float
    
    sub r8, '0'
    mul r9
    add rax, r8
    inc rbx
    jmp loop_convert_float
    
fim_convert_float:
    cmp cl, 1
    jne positivo_float
    neg rax
positivo_float:
    pop rdx
    pop rcx
    pop rbx
    leave
    ret
    
erro_convert_float:
    mov rax, -1  ; Valor de erro (consistente com string_to_int)
    pop rdx
    pop rcx
    pop rbx
    leave
    ret

; ================================================================
; Função: Converter string para inteiro
; Entrada: RDI = string
; Saída: RAX = número (-1 se erro)
; ================================================================
string_to_int:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    
    mov rbx, rdi
    xor rax, rax
    xor rcx, rcx
    mov r9, 10         ; Usar r9 para base (rdx é usado por mul!)
    
    ; Pular espaços iniciais
skip_spaces:
    cmp byte [rbx], ' '
    jne check_sign
    inc rbx
    jmp skip_spaces
    
    ; Verificar sinal negativo
check_sign:
    cmp byte [rbx], '-'
    jne loop_convert
    mov cl, 1
    inc rbx
    
loop_convert:
    movzx r8, byte [rbx]
    cmp r8, 0
    je fim_convert
    cmp r8, 10
    je fim_convert
    cmp r8, 13
    je fim_convert
    cmp r8, '0'
    jb erro_convert
    cmp r8, '9'
    ja erro_convert
    
    sub r8, '0'
    mul r9             ; Multiplicar por 10 (usando r9, não rdx!)
    add rax, r8
    inc rbx
    jmp loop_convert
    
fim_convert:
    cmp cl, 1
    jne positivo
    neg rax
positivo:
    pop rdx
    pop rcx
    pop rbx
    leave
    ret
    
erro_convert:
    mov rax, -1
    pop rdx
    pop rcx
    pop rbx
    leave
    ret

; ================================================================
; Função: Imprimir número decimal
; Entrada: EDI = número
; ================================================================
print_decimal:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push r12
    
    mov eax, edi
    mov ebx, 10
    mov r12d, 0
    
    ; Verificar sinal negativo
    test eax, eax
    jns positivo_decimal
    neg eax
    push '-'
    inc r12d
    
positivo_decimal:
    ; Separar dígitos
    cmp eax, 0
    jne separar_digitos_decimal
    push '0'
    inc r12d
    jmp imprimir_digitos
    
separar_digitos_decimal:
    mov edx, 0
    div ebx
    add edx, '0'
    push rdx
    inc r12d
    cmp eax, 0
    jg separar_digitos_decimal
    
    ; Imprimir dígitos
imprimir_digitos:
    pop rdx
    mov [buffer_numero], dl
    mov byte [buffer_numero + 1], 0
    mov rdi, buffer_numero
    call print_string
    dec r12d
    cmp r12d, 0
    jg imprimir_digitos
    
    pop r12
    pop rdx
    pop rcx
    pop rbx
    leave
    ret

; ================================================================
; Função: Imprimir string
; Entrada: RDI = endereço da string
; ================================================================
print_string:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push rsi
    
    mov rbx, rdi
    mov rdx, 0
    
    ; Calcular tamanho da string
calc_len:
    cmp byte [rbx + rdx], 0
    je print_len
    inc rdx
    jmp calc_len
    
print_len:
    ; Syscall write
    mov rax, 1
    mov rsi, rbx
    mov rdi, 1
    syscall
    
    ; Verificar se houve erro no write (rdx contém bytes escritos)
    ; Se rax < 0, houve erro, mas continuamos mesmo assim
    
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    leave
    ret

; ================================================================
; Função: Ler entrada do usuário
; Entrada: RDI = buffer, RSI = tamanho máximo
; ================================================================
read_input:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push rsi
    
    ; Syscall read
    mov rax, 0
    mov rdx, rsi      ; Tamanho máximo
    mov rsi, rdi      ; Buffer
    mov rdi, 0        ; stdin
    syscall
    
    ; Verificar se houve erro na leitura
    cmp rax, 0
    jl read_error
    
    ; Adicionar null terminator se necessário
    cmp rax, 0
    je read_done
    
    ; Substituir newline por null terminator
    cmp rax, 1
    jl read_done
    
    ; Verificar se o último caractere é newline
    mov rbx, rsi
    add rbx, rax
    sub rbx, 1
    cmp byte [rbx], 10
    je replace_newline
    cmp byte [rbx], 13
    je replace_newline
    
    ; Se não for newline, adicionar null terminator no final
    mov byte [rsi + rax], 0
    jmp read_done
    
replace_newline:
    mov byte [rbx], 0
    jmp read_done
    
read_error:
    ; Em caso de erro, garantir buffer válido
    mov byte [rsi], 0
    
read_done:
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    leave
    ret

; ================================================================
; Sair do programa
; ================================================================
sair:
    mov rdi, msg_saindo
    call print_string
    
    ; Syscall exit com código de sucesso
    mov rax, 60
    mov rdi, 0
    syscall

; ================================================================
; Proteção: nunca deve chegar aqui
; Se chegar, há um problema no fluxo do programa
; ================================================================
protecao_fim:
    ; Em caso de erro inesperado, voltar ao menu
    jmp menu_loop
