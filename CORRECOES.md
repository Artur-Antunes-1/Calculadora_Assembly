# Correções Aplicadas

## Problemas Identificados e Corrigidos

### 1. Loops Infinitos
- **Causa**: Funções `print_decimal` e `print_string` não preservavam corretamente todos os registradores, causando corrupção de contadores de loop
- **Solução**: Adicionada preservação completa de registradores (rbx, rcx, rdx, rsi, r12, r13, r14, r15) em todas as funções de I/O

### 2. Problema no BCD
- **Causa**: A função `read_input` não estava tratando corretamente o newline no final da entrada
- **Solução**: Melhorado tratamento de newline (10 e 13) para garantir leitura correta do número completo

### 3. Preservação de Registradores
- **Causa**: Funções chamadas dentro de loops não preservavam registradores usados pelos loops
- **Solução**: Adicionado push/pop de todos os registradores críticos antes/depois de chamadas de função

## Para Testar

Recompile e teste:
```bash
wsl make clean
wsl make
wsl ./calculadora
```

Teste especialmente:
- Opção 1: Binário (ex: 42)
- Opção 2: Octal (ex: 255)  
- Opção 3: Hexadecimal (ex: 255)
- Opção 4: BCD (ex: 123) - deve mostrar todos os dígitos
- Opção 5: Float (ex: 12)

