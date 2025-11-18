# Instalação e Compilação no Windows

Este documento explica como compilar e executar a Calculadora Programador Didática no Windows.

## ⚠️ IMPORTANTE

O código Assembly atual foi desenvolvido para **Linux x86-64** e usa chamadas de sistema (syscalls) do Linux. Para executar no Windows, você tem duas opções principais:

### Opção 1: Usar WSL (Recomendado) ⭐

O **WSL (Windows Subsystem for Linux)** permite executar código Linux diretamente no Windows.

#### Passo 1: Instalar WSL

No PowerShell (como Administrador):
```powershell
wsl --install
```

Ou se já tiver WSL:
```powershell
wsl --install -d Ubuntu
```

#### Passo 2: Instalar NASM no WSL

Abra o terminal WSL (Ubuntu) e execute:
```bash
sudo apt-get update
sudo apt-get install nasm
```

#### Passo 3: Compilar e Executar

No terminal WSL:
```bash
cd /mnt/c/Users/artur/Área\ de\ Trabalho/Artur\ Faculdade/InfraHardware/Calculadora
make
./calculadora
```

Ou use o script PowerShell:
```powershell
wsl make
wsl ./calculadora
```

---

### Opção 2: Adaptar para Windows Native

Para executar nativamente no Windows, seria necessário adaptar o código para usar WinAPI em vez de syscalls do Linux. Isso requer mudanças significativas.

#### Instalação de Ferramentas (se optar por Windows Native)

1. **Instalar NASM:**
   - Baixe de: https://www.nasm.us/pub/nasm/releasebuilds/
   - Extraia para `C:\nasm`
   - Adicione `C:\nasm` ao PATH do sistema

2. **Instalar um Linker:**
   
   **Opção A: GOLink (Mais simples)**
   - Baixe de: https://www.godevtool.com/Golink.zip
   - Extraia para `C:\golink`
   - Adicione `C:\golink` ao PATH
   
   **Opção B: MSVC Linker**
   - Instale Visual Studio Build Tools
   - Ou use o linker que vem com o Visual Studio

3. **Compilar:**

   Com GOLink:
   ```powershell
   nasm -f win64 calculadora.asm -o calculadora.obj
   golink /console /entry _main calculadora.obj kernel32.dll msvcrt.dll
   ```

   Com MSVC Linker:
   ```powershell
   nasm -f win64 calculadora.asm -o calculadora.obj
   link /subsystem:console /entry:main calculadora.obj kernel32.lib
   ```

#### ⚠️ Problema: O código atual usa syscalls do Linux

O código atual em `calculadora.asm` usa:
- `syscall` (específico do Linux)
- Chamadas como `rax=1` (write), `rax=0` (read), `rax=60` (exit)

Para Windows, seria necessário:
- Usar WinAPI (kernel32.dll)
- Chamar funções como `WriteFile`, `ReadFile`, `ExitProcess`
- Modificar todas as funções de I/O

---

## 🚀 Solução Rápida: Script PowerShell

Use o script `compilar.ps1` que tenta detectar as ferramentas disponíveis:

```powershell
.\compilar.ps1
```

---

## 📋 Resumo das Opções

| Opção | Dificuldade | Tempo | Recomendado |
|-------|-------------|-------|-------------|
| WSL | ⭐ Fácil | 5-10 min | ✅ Sim |
| Adaptar para Windows | ⭐⭐⭐ Difícil | 2-3 horas | ❌ Não |
| Máquina Virtual Linux | ⭐⭐ Médio | 15-20 min | ✅ Alternativa |

---

## 🔧 Verificar Instalações

### Verificar NASM:
```powershell
nasm --version
```

### Verificar WSL:
```powershell
wsl --status
```

### Verificar GOLink:
```powershell
golink
```

---

## 📚 Recursos Adicionais

- [Documentação NASM](https://www.nasm.us/docs.php)
- [Documentação WSL](https://docs.microsoft.com/windows/wsl/)
- [GOLink Download](https://www.godevtool.com/)

---

## ❓ Dúvidas?

Se tiver problemas, verifique:
1. Se o NASM está instalado e no PATH
2. Se o WSL está funcionando corretamente
3. Se as permissões do PowerShell permitem executar scripts (Execute: `Set-ExecutionPolicy RemoteSigned`)

