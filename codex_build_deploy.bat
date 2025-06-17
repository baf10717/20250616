@echo off
REM Build and deploy the HelloCodex Revit add-in

setlocal

REM Directory of this script
set SCRIPT_DIR=%~dp0
set PROJECT_DIR=%SCRIPT_DIR%RevitAddin
set CONFIG=Release
set PLATFORM=x64

REM Revit add-ins folder
set ADDINS_DIR=%APPDATA%\Autodesk\Revit\Addins\2022

REM Build the project
msbuild "%PROJECT_DIR%\HelloCodex.csproj" /p:Configuration=%CONFIG% /p:Platform=%PLATFORM%

REM Copy output DLL and addin manifest
if not exist "%ADDINS_DIR%" mkdir "%ADDINS_DIR%"
copy "%PROJECT_DIR%\bin\%PLATFORM%\%CONFIG%\HelloCodex.dll" "%ADDINS_DIR%" /Y
copy "%PROJECT_DIR%\HelloCodex.addin" "%ADDINS_DIR%" /Y

endlocal

echo Build and deployment finished.
