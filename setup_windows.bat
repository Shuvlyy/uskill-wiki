@echo off
:: admin privileges ::
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"

echo U-Skill Wiki installation

:: check virtualization features ::
echo Checking virtualization features (WSL)...
powershell -Command "if ((Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State -eq 'Enabled') { exit 0 } else { exit 1 }"
set VMP_ENABLED=%errorlevel%
powershell -Command "if ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq 'Enabled') { exit 0 } else { exit 1 }"
set WSL_ENABLED=%errorlevel%

if %VMP_ENABLED% neq 0 set NEED_REBOOT=1
if %WSL_ENABLED% neq 0 set NEED_REBOOT=1

if defined NEED_REBOOT (
    echo Enabling virtualization features, this might take a minute...
    dism.exe /online /Enable-Feature /All /FeatureName:VirtualMachinePlatform /NoRestart
    dism.exe /online /Enable-Feature /All /FeatureName:Microsoft-Windows-Subsystem-Linux /NoRestart
    bcdedit /set hypervisorlaunchtype auto
    wsl --install -d Ubuntu
    echo ==================================================
    echo Virtualization features have been enabled!
    echo A system restart is REQUIRED to continue the installation.
    echo Please restart your computer, then run this script again.
    echo ==================================================
    pause
    exit /b 0
)

:: install docker desktop ::
echo Installing Docker Desktop (docker)...
winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements

:: docker desktop startup ::
:: make sure docker command is available in this session (in case it was just installed)
set "PATH=%PATH%;C:\Program Files\Docker\Docker\resources\bin"
echo Starting Docker Desktop...
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
echo Waiting for Docker service to spool up...

:wait_for_docker
docker ps >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker is still starting, waiting...
    timeout /t 5 /nobreak >nul
    goto wait_for_docker
)

:: .env setup lol ::
if not exist .env (
    echo Please fill up the .env file ^(admin email + password^).
    pause
    exit /b 0
) else (
    echo Environment variables are already set.
)

:: project startup!! ::
echo Starting up U-Skill Wiki...
docker compose up --build -d

echo ==================================================
echo Project has been started.
echo App can be accessed on: http://localhost:8080
echo And, if you are curious, API can be accessed on: http://localhost:8000
echo ==================================================
echo If you want to stop the project, simply type "docker compose down" in the console.
echo You can now close this window by pressing any key...
pause >nul
