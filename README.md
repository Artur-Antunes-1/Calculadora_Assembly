# Calculadora Programador Didática

Uma calculadora didática implementada em Assembly x86-64 que realiza conversões de bases numéricas e análise de números em ponto flutuante IEEE 754, mostrando todos os passos das operações.

## Funcionalidades

### 1. Conversões de Base 10 para:
   - **Base 2 (Binário)**: Converte números decimais para binário, mostrando cada passo da divisão por 2
   - **Base 8 (Octal)**: Converte números decimais para octal, mostrando cada passo da divisão por 8
   - **Base 16 (Hexadecimal)**: Converte números decimais para hexadecimal, mostrando cada passo da divisão por 16
   - **BCD (Binary Coded Decimal)**: Converte cada dígito decimal para sua representação BCD de 4 bits

### 2. Conversão para Float IEEE 754:
   - Converte números reais decimais para representação float IEEE 754
   - Mostra detalhadamente:
     - Bit de sinal (1 bit)
     - Expoente (8 bits) com valor com viés e valor real
     - Fração/Mantissa (23 bits)
     - Representação binária completa (32 bits)
     - Representação hexadecimal

## Requisitos

- Sistema operacional Linux (64 bits)
- NASM (Netwide Assembler) versão 2.10 ou superior
- LD (GNU Linker)

## Compilação

### ⚠️ IMPORTANTE: Windows vs Linux

Este código foi desenvolvido para **Linux x86-64**. Se você está no Windows, veja `INSTALACAO_WINDOWS.md` para instruções detalhadas.

**Opção Recomendada para Windows:**
Use WSL (Windows Subsystem for Linux) - veja `INSTALACAO_WINDOWS.md`

### Linux

#### Instalar NASM (se necessário)

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install nasm
```

**Fedora:**
```bash
sudo dnf install nasm
```

**Arch Linux:**
```bash
sudo pacman -S nasm
```

#### Compilar o programa

Usando o Makefile:
```bash
make
```

Ou manualmente:
```bash
nasm -f elf64 calculadora.asm -o calculadora.o
ld -o calculadora calculadora.o
```

### Windows

#### Método 1: WSL (Recomendado) ⭐

```powershell
# Instalar WSL (se ainda não tiver)
wsl --install

# No WSL, instalar NASM
wsl sudo apt-get update
wsl sudo apt-get install nasm

# Compilar via script PowerShell
.\compilar_wsl.ps1

# Ou diretamente via WSL
wsl make
```

#### Método 2: Script PowerShell

```powershell
# Tentar compilar nativamente (requer adaptações)
.\compilar.ps1
```

**Nota:** O código atual precisa ser adaptado para Windows. Veja `INSTALACAO_WINDOWS.md` para detalhes.

## Execução

### Linux ou WSL:
```bash
./calculadora
```

Ou usando o Makefile:
```bash
make run
```

### Windows via WSL:
```powershell
wsl ./calculadora
```

## Como Usar

1. Execute o programa
2. Escolha uma das opções do menu:
   - **1**: Converter decimal para binário
   - **2**: Converter decimal para octal
   - **3**: Converter decimal para hexadecimal
   - **4**: Converter decimal para BCD
   - **5**: Converter real para float IEEE 754
   - **0**: Sair do programa
3. Digite o número quando solicitado
4. Observe os passos da conversão sendo exibidos
5. Veja o resultado final

## Exemplos de Saída

### Conversão para Binário
```
=== CONVERSAO PARA BASE 2 (BINARIO) ===

--- PASSOS DA CONVERSAO ---
Numero original: 42

Passo: 42 / 2 = 21 (resto: 0)
Passo: 21 / 2 = 10 (resto: 1)
Passo: 10 / 2 = 5 (resto: 0)
Passo: 5 / 2 = 2 (resto: 1)
Passo: 2 / 2 = 1 (resto: 0)
Passo: 1 / 2 = 0 (resto: 1)

RESULTADO FINAL: 101010
```

### Conversão para Float IEEE 754
```
=== CONVERSAO PARA FLOAT IEEE 754 ===

Numero original: 12.5

Representacao binaria completa (32 bits): 01000001010010000000000000000000
Representacao hexadecimal: 0x41480000

Bit de Sinal (1 bit): 0

Expoente (8 bits): 10000010
  (valor com viés 127): 130
  (valor real do expoente): 3

Fracao/Mantissa (23 bits): 10010000000000000000000
```

## Estrutura do Código

- `calculadora.asm`: Código fonte principal em Assembly
- `Makefile`: Arquivo para facilitar compilação
- `README.md`: Este arquivo com documentação

## Limitações

- Operações encerram com código de erro 1 apesar de estarem funcionando
- É necessário rodar novamente para realizar outra operação
- O programa foi desenvolvido para sistemas Linux 64-bit

## Notas Técnicas

- O programa usa chamadas de sistema Linux (syscalls) para I/O
- Todas as conversões são feitas mostrando os passos intermediários
- O formato IEEE 754 é o padrão de 32 bits (single precision)

## Licença

Este projeto é de código aberto e pode ser usado livremente para fins educacionais.

