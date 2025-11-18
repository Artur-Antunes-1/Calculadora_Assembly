# Script PowerShell para compilar a Calculadora Programador Didática
# Requer NASM e um linker (GOLink ou MSVC linker)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Calculadora Programador Didatica" -ForegroundColor Cyan
Write-Host "  Script de Compilacao para Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se NASM está instalado
$nasmPath = Get-Command nasm -ErrorAction SilentlyContinue
if (-not $nasmPath) {
    Write-Host "ERRO: NASM nao encontrado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Para instalar NASM no Windows:" -ForegroundColor Yellow
    Write-Host "1. Baixe de: https://www.nasm.us/pub/nasm/releasebuilds/" -ForegroundColor Yellow
    Write-Host "2. Extraia para C:\nasm" -ForegroundColor Yellow
    Write-Host "3. Adicione C:\nasm ao PATH" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "OU use WSL (Windows Subsystem for Linux) com:" -ForegroundColor Yellow
    Write-Host "  sudo apt-get install nasm" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "NASM encontrado: $($nasmPath.Source)" -ForegroundColor Green
Write-Host ""

# Tentar compilar para Windows
Write-Host "Tentando compilar para Windows..." -ForegroundColor Yellow

# Tentar encontrar um linker
$golink = Get-Command golink -ErrorAction SilentlyContinue
$link = Get-Command link -ErrorAction SilentlyContinue

if ($golink) {
    Write-Host "Usando GOLink..." -ForegroundColor Green
    Write-Host "Compilando calculadora.asm..." -ForegroundColor Yellow
    nasm -f win64 calculadora.asm -o calculadora.obj
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ligando..." -ForegroundColor Yellow
        golink /console /entry _main calculadora.obj kernel32.dll msvcrt.dll
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "Compilacao concluida com sucesso!" -ForegroundColor Green
            Write-Host "Execute: .\calculadora.exe" -ForegroundColor Cyan
        } else {
            Write-Host "Erro na ligacao!" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Erro na compilacao!" -ForegroundColor Red
        exit 1
    }
} elseif ($link) {
    Write-Host "Usando MSVC Linker..." -ForegroundColor Green
    Write-Host "Compilando calculadora.asm..." -ForegroundColor Yellow
    nasm -f win64 calculadora.asm -o calculadora.obj
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ligando..." -ForegroundColor Yellow
        link /subsystem:console /entry:main calculadora.obj kernel32.lib
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "Compilacao concluida com sucesso!" -ForegroundColor Green
            Write-Host "Execute: .\calculadora.exe" -ForegroundColor Cyan
        } else {
            Write-Host "Erro na ligacao!" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Erro na compilacao!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "AVISO: Nenhum linker encontrado!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opcoes:" -ForegroundColor Yellow
    Write-Host "1. Instalar GOLink:" -ForegroundColor Yellow
    Write-Host "   - Baixe de: https://www.godevtool.com/Golink.zip" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "2. Usar WSL (recomendado para este projeto):" -ForegroundColor Yellow
    Write-Host "   - O codigo foi desenvolvido para Linux" -ForegroundColor Yellow
    Write-Host "   - Execute: wsl make" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "3. Adaptar o codigo para Windows (requer modificacoes significativas)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Apenas compilando objeto para inspecao..." -ForegroundColor Yellow
    nasm -f win64 calculadora.asm -o calculadora.obj
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Arquivo calculadora.obj criado (mas precisa de ligacao)" -ForegroundColor Yellow
    }
}

