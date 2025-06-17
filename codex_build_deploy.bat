@echo off

REM Restore packages to generate project.assets.json
msbuild "%PROJECT%" /t:Restore /p:Configuration=%CONFIG% /p:Platform=%PLATFORM%
if errorlevel 1 (
    echo Restore failed.
    exit /b 1
)

setlocal

REM Build and deploy HelloCodex Revit add-in
set "CONFIG=Release"
set "PLATFORM=x64"

set "PROJECT=%~dp0RevitAddin\RevitAddin.csproj"

msbuild "%PROJECT%" /p:Configuration=%CONFIG% /p:Platform=%PLATFORM%
if errorlevel 1 (
    echo Build failed.
    exit /b 1
)

set "DEST=%AppData%\Autodesk\Revit\Addins\2022"
if not exist "%DEST%" (
    mkdir "%DEST%"
)

copy "%~dp0RevitAddin\bin\%PLATFORM%\%CONFIG%\HelloCodex.dll" "%DEST%\HelloCodex.dll" /Y
copy "%~dp0RevitAddin\HelloCodex.addin" "%DEST%\HelloCodex.addin" /Y

echo Deployment completed.
endlocal
yment finished.

