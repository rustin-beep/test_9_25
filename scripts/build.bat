@echo off
setlocal
cd /d "%~dp0.."

rem ============================================================
rem  Cross-machine build script: CMake + MSVC (Visual Studio)
rem
rem  - Finds the latest Visual Studio automatically via vswhere
rem    (no hardcoded install path, works for VS2019/2022/2026...)
rem  - Prefers the CMake bundled with Visual Studio, so the
rem    generator always matches the installed compiler version.
rem
rem  Usage:  build.bat [debug|release] [run]
rem ============================================================

set "CONFIG=Debug"
set "RUN=0"

:parse_args
if /i "%~1"=="debug"   ( set "CONFIG=Debug"   & shift & goto parse_args )
if /i "%~1"=="release" ( set "CONFIG=Release" & shift & goto parse_args )
if /i "%~1"=="run"     ( set "RUN=1"          & shift & goto parse_args )
if not "%~1"=="" (
    shift
    goto parse_args
)

rem ---- 1. Locate Visual Studio (the one with MSVC) ----
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" (
    echo [ERROR] vswhere.exe not found. Install Visual Studio with the "Desktop development with C++" workload.
    exit /b 1
)
set "VS_PATH="
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VS_PATH=%%i"
if not defined VS_PATH (
    for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -property installationPath`) do set "VS_PATH=%%i"
)
if not defined VS_PATH (
    echo [ERROR] No Visual Studio installation found. Install the "Desktop development with C++" workload.
    exit /b 1
)
echo [INFO] Visual Studio: %VS_PATH%

rem ---- 2. Pick CMake: the one bundled with VS first, else PATH ----
set "CMAKE=%VS_PATH%\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
if not exist "%CMAKE%" set "CMAKE=cmake"
"%CMAKE%" --version >nul 2>nul
if errorlevel 1 (
    echo [ERROR] CMake not found. Install the "C++ CMake tools" component in Visual Studio, or install CMake separately.
    exit /b 1
)

rem ---- 3. Configure + build (CMake picks the Visual Studio generator itself) ----
if not exist build mkdir build
echo [INFO] Configuring ^(build type: %CONFIG%^)...
"%CMAKE%" -S . -B build || exit /b 1
echo [INFO] Building...
"%CMAKE%" --build build --config %CONFIG% || exit /b 1

echo.
echo [OK] Build succeeded: build\bin\app.exe

if "%RUN%"=="1" (
    echo [INFO] Running build\bin\app.exe ...
    build\bin\app.exe
)

endlocal
