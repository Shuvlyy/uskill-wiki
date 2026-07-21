@echo off
echo U-Skill Wiki installation

:: install python ::
echo Installing Python...
winget install -e --id Python.Python.3.11 --accept-package-agreements --accept-source-agreements

:: install docker desktop ::
echo Installing Docker Desktop (docker)...
winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements

:: docker desktop startup ::
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
pause >nul
