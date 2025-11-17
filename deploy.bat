@echo off
REM EngiTrack Docker Deployment Script for Windows
REM This script helps build and deploy the EngiTrack Flutter web app

echo.
echo ============================================
echo   EngiTrack Docker Deployment Script
echo ============================================
echo.

REM Check if Docker is installed
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not installed. Please install Docker Desktop first.
    exit /b 1
)

REM Check if Docker Compose is available
docker compose version >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set USE_COMPOSE=true
) else (
    set USE_COMPOSE=false
    echo [WARNING] Docker Compose not found. Using docker commands instead.
)

if "%1"=="build" goto build
if "%1"=="run" goto run
if "%1"=="stop" goto stop
if "%1"=="logs" goto logs
if "%1"=="status" goto status
if "%1"=="restart" goto restart
if "%1"=="clean" goto clean
goto help

:build
echo [INFO] Building Docker image...
docker build -t engitrack:latest .
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Build complete!
) else (
    echo [ERROR] Build failed!
    exit /b 1
)
goto end

:run
if "%USE_COMPOSE%"=="true" (
    echo [INFO] Starting with Docker Compose...
    docker compose up -d --build
    if %ERRORLEVEL% EQU 0 (
        echo [SUCCESS] Container started!
        echo [INFO] Access the app at: http://localhost:8080
    ) else (
        echo [ERROR] Failed to start container!
        exit /b 1
    )
) else (
    call :build
    echo [INFO] Starting Docker container...
    docker run -d -p 8080:80 --name engitrack-web engitrack:latest
    if %ERRORLEVEL% EQU 0 (
        echo [SUCCESS] Container started!
        echo [INFO] Access the app at: http://localhost:8080
    ) else (
        echo [ERROR] Failed to start container!
        exit /b 1
    )
)
goto end

:stop
echo [INFO] Stopping container...
if "%USE_COMPOSE%"=="true" (
    docker compose down
) else (
    docker stop engitrack-web 2>nul
    docker rm engitrack-web 2>nul
)
echo [SUCCESS] Container stopped!
goto end

:logs
echo [INFO] Viewing logs...
if "%USE_COMPOSE%"=="true" (
    docker compose logs -f
) else (
    docker logs -f engitrack-web
)
goto end

:status
echo [INFO] Container status:
if "%USE_COMPOSE%"=="true" (
    docker compose ps
) else (
    docker ps -a | findstr engitrack-web
)
goto end

:restart
call :stop
timeout /t 2 /nobreak >nul
call :run
goto end

:clean
echo [INFO] Cleaning up...
call :stop
docker rmi engitrack:latest 2>nul
docker system prune -f
echo [SUCCESS] Cleanup complete!
goto end

:help
echo.
echo Usage: %0 {build^|run^|stop^|logs^|status^|restart^|clean}
echo.
echo Commands:
echo   build    - Build the Docker image
echo   run      - Build and run the container
echo   stop     - Stop the container
echo   logs     - View container logs
echo   status   - Check container status
echo   restart  - Restart the container
echo   clean    - Stop and remove containers/images
echo.
goto end

:end

