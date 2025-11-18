# Script PowerShell para compilar via WSL
# Este é o método recomendado, pois o código foi desenvolvido para Linux

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Calculadora Programador Didatica" -ForegroundColor Cyan
Write-Host "  Compilacao via WSL (Recomendado)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se WSL está instalado
$wslAvailable = Get-Command wsl -ErrorAction SilentlyContinue
if (-not $wslAvailable) {
    Write-Host "ERRO: WSL nao encontrado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Para instalar WSL, execute no PowerShell (como Administrador):" -ForegroundColor Yellow
    Write-Host "  wsl --install" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Depois, instale o NASM no WSL:" -ForegroundColor Yellow
    Write-Host "  wsl sudo apt-get update" -ForegroundColor Yellow
    Write-Host "  wsl sudo apt-get install nasm" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "WSL encontrado!" -ForegroundColor Green
Write-Host ""

# Obter caminho atual e converter para formato WSL
$currentPath = (Get-Location).Path
$wslPath = $currentPath -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/'
$wslPath = $wslPath.ToLower()

Write-Host "Caminho WSL: $wslPath" -ForegroundColor Gray
Write-Host ""

# Verificar se NASM está instalado no WSL
Write-Host "Verificando NASM no WSL..." -ForegroundColor Yellow
$nasmCheck = wsl which nasm 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "NASM nao encontrado no WSL!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Deseja instalar o NASM agora? (S/N)" -ForegroundColor Cyan
    $response = Read-Host
    if ($response -eq 'S' -or $response -eq 's') {
        Write-Host "Instalando NASM..." -ForegroundColor Yellow
        wsl sudo apt-get update
        wsl sudo apt-get install -y nasm
        if ($LASTEXITCODE -eq 0) {
            Write-Host "NASM instalado com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "Erro na instalacao do NASM!" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Instalacao cancelada." -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "NASM encontrado: $nasmCheck" -ForegroundColor Green
}

Write-Host ""

# Compilar usando WSL
Write-Host "Compilando via WSL..." -ForegroundColor Yellow
Write-Host ""

wsl bash -c "cd '$wslPath' && make"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Compilacao concluida com sucesso!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Para executar, use:" -ForegroundColor Cyan
    Write-Host "  wsl ./calculadora" -ForegroundColor White
    Write-Host ""
    Write-Host "Ou entre no WSL e execute:" -ForegroundColor Cyan
    Write-Host "  wsl" -ForegroundColor White
    Write-Host "  cd $wslPath" -ForegroundColor White
    Write-Host "  ./calculadora" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "Erro na compilacao!" -ForegroundColor Red
    Write-Host "Verifique se o Makefile esta correto e se o NASM esta funcionando." -ForegroundColor Yellow
    exit 1
}

