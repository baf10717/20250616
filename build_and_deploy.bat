@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo ========================================
echo   BAF Tool Suite - 建置與部署
echo ========================================
echo.

:: 設定路徑變數
set "MSBUILD_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
set "REVIT_ADDIN_DIR=C:\Users\%USERNAME%\AppData\Roaming\Autodesk\Revit\Addins\2022"
set "DEPLOY_SET_DIR=%REVIT_ADDIN_DIR%\BAF set"
set "DEPLOY_CHECK_DIR=%REVIT_ADDIN_DIR%\BAF check"
set "DEPLOY_OPTION_DIR=%REVIT_ADDIN_DIR%\BAF option"

:: 環境檢查
echo [步驟 1] 檢查 MSBuild.exe...
if not exist "%MSBUILD_PATH%" (
    echo [錯誤] 找不到 MSBuild.exe
    pause
    exit /b 1
)
echo [成功] MSBuild 已找到。
echo.

:: 檢查是否需要關閉 Revit
echo [步驟 2] 檢查 Revit 程序...
tasklist /FI "IMAGENAME eq Revit.exe" 2>NUL | find /I /N "Revit.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [警告] 偵測到 Revit 正在執行，將嘗試關閉...
    taskkill /F /IM "Revit.exe" >nul 2>&1
    timeout /t 3 >nul
    echo [成功] Revit 已關閉。
)
echo.

:: 清理舊檔案
echo [步驟 3] 清理舊的部署檔案...
if not exist "%DEPLOY_SET_DIR%" mkdir "%DEPLOY_SET_DIR%"
if not exist "%DEPLOY_CHECK_DIR%" mkdir "%DEPLOY_CHECK_DIR%"
if not exist "%DEPLOY_OPTION_DIR%" mkdir "%DEPLOY_OPTION_DIR%"

if exist "%DEPLOY_SET_DIR%\*.dll" del /q "%DEPLOY_SET_DIR%\*.dll"
if exist "%DEPLOY_CHECK_DIR%\*.dll" del /q "%DEPLOY_CHECK_DIR%\*.dll"
if exist "%DEPLOY_OPTION_DIR%\*.dll" del /q "%DEPLOY_OPTION_DIR%\*.dll"
if exist "%REVIT_ADDIN_DIR%\BAF_tool.addin" del /q "%REVIT_ADDIN_DIR%\BAF_tool.addin"
echo [成功] 清理完成。
echo.

:: 編譯專案
echo [步驟 4] 編譯所有專案...
set "COMPILE_ERROR="

echo   - 編譯中: WeeklyTasks
"%MSBUILD_PATH%" "BAF set\WeeklyTasks\WeeklyTasks.csproj" /t:Restore /p:Configuration=Release /p:Platform="x64" /verbosity:minimal
"%MSBUILD_PATH%" "BAF set\WeeklyTasks\WeeklyTasks.csproj" /p:Configuration=Release /p:Platform="x64" /verbosity:minimal
if !errorlevel! neq 0 ( set "COMPILE_ERROR=true" & echo   [錯誤] WeeklyTasks 編譯失敗! )

echo   - 編譯中: ControlElementsInView
"%MSBUILD_PATH%" "BAF set\ControlElementsInView\ControlElementsInView.csproj" /t:Restore /p:Configuration=Release /p:Platform="x64" /verbosity:minimal
"%MSBUILD_PATH%" "BAF set\ControlElementsInView\ControlElementsInView.csproj" /p:Configuration=Release /p:Platform="x64" /verbosity:minimal
if !errorlevel! neq 0 ( set "COMPILE_ERROR=true" & echo   [錯誤] ControlElementsInView 編譯失敗! )

echo   - 編譯中: StructureCheck
"%MSBUILD_PATH%" "BAF check\StructureCheck\StructureCheck.csproj" /t:Restore /p:Configuration=Release /p:Platform="x64" /verbosity:minimal
"%MSBUILD_PATH%" "BAF check\StructureCheck\StructureCheck.csproj" /p:Configuration=Release /p:Platform="x64" /verbosity:minimal
if !errorlevel! neq 0 ( set "COMPILE_ERROR=true" & echo   [錯誤] StructureCheck 編譯失敗! )

echo   - 編譯中: ElementMonitoring
"%MSBUILD_PATH%" "BAF check\ElementMonitoring\ElementMonitoring.csproj" /t:Restore /p:Configuration=Release /p:Platform="x64" /verbosity:minimal
"%MSBUILD_PATH%" "BAF check\ElementMonitoring\ElementMonitoring.csproj" /p:Configuration=Release /p:Platform="x64" /verbosity:minimal
if !errorlevel! neq 0 ( set "COMPILE_ERROR=true" & echo   [錯誤] ElementMonitoring 編譯失敗! )

echo   - 編譯中: BAF_option
"%MSBUILD_PATH%" "BAF option\BAF_option.csproj" /t:Restore /p:Configuration=Release /p:Platform="x64" /verbosity:minimal
"%MSBUILD_PATH%" "BAF option\BAF_option.csproj" /p:Configuration=Release /p:Platform="x64" /verbosity:minimal
if !errorlevel! neq 0 ( set "COMPILE_ERROR=true" & echo   [錯誤] BAF_option 編譯失敗! )

if defined COMPILE_ERROR (
    echo.
    echo [重大錯誤] 編譯過程中發生錯誤，部署中止。
    pause
    exit /b 1
)
echo [成功] 所有專案編譯完成。
echo.

:: 部署檔案
echo [步驟 5] 部署檔案...
copy "BAF set\WeeklyTasks\bin\x64\Release\WeeklyTasks.dll" "%DEPLOY_SET_DIR%\" > nul
copy "BAF set\ControlElementsInView\bin\x64\Release\ControlElementsInView.dll" "%DEPLOY_SET_DIR%\" > nul
copy "BAF check\StructureCheck\bin\x64\Release\net48\StructureCheck.dll" "%DEPLOY_CHECK_DIR%\" > nul
copy "BAF check\ElementMonitoring\bin\x64\Release\net48\ElementMonitoring.dll" "%DEPLOY_CHECK_DIR%\" > nul
copy "BAF option\bin\x64\Release\BAF_option.dll" "%DEPLOY_OPTION_DIR%\" > nul
copy "BAF option\BAF_tool.addin" "%REVIT_ADDIN_DIR%\" > nul
echo [成功] 檔案部署完成。
echo.

:: 最終驗證
echo [步驟 6] 最終驗證...
set "VERIFY_ERROR="
if not exist "%DEPLOY_SET_DIR%\WeeklyTasks.dll" ( echo [錯誤] 缺少檔案: WeeklyTasks.dll & set "VERIFY_ERROR=true" )
if not exist "%DEPLOY_SET_DIR%\ControlElementsInView.dll" ( echo [錯誤] 缺少檔案: ControlElementsInView.dll & set "VERIFY_ERROR=true" )
if not exist "%DEPLOY_CHECK_DIR%\StructureCheck.dll" ( echo [錯誤] 缺少檔案: StructureCheck.dll & set "VERIFY_ERROR=true" )
if not exist "%DEPLOY_CHECK_DIR%\ElementMonitoring.dll" ( echo [錯誤] 缺少檔案: ElementMonitoring.dll & set "VERIFY_ERROR=true" )
if not exist "%DEPLOY_OPTION_DIR%\BAF_option.dll" ( echo [錯誤] 缺少檔案: BAF_option.dll & set "VERIFY_ERROR=true" )
if not exist "%REVIT_ADDIN_DIR%\BAF_tool.addin" ( echo [錯誤] 缺少檔案: BAF_tool.addin & set "VERIFY_ERROR=true" )

if defined VERIFY_ERROR (
    echo.
    echo [重大錯誤] 驗證失敗，部署不完整!
    pause
    exit /b 1
)
echo [成功] 部署成功並通過驗證!
echo.

:: 啟動 Revit
echo [步驟 7] 檢查並啟動 Revit 2022...
tasklist /FI "IMAGENAME eq Revit.exe" 2>NUL | find /I /N "Revit.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [資訊] Revit 已在執行中，無需重複啟動。
) else (
    echo   正在啟動 Revit 2022...
    start "" "C:\Program Files\Autodesk\Revit 2022\Revit.exe"
    if !errorlevel! neq 0 (
        echo [警告] 無法自動啟動 Revit，請手動啟動。
    ) else (
        echo [成功] Revit 2022 已啟動。
    )
)
echo.

:: 完成
echo ========================================
echo   部署完成!
echo ========================================
echo.
echo 視窗將在 30 秒後自動關閉...
timeout /t 30 >nul 