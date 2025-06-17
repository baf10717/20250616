# 20250616

This repository contains a minimal Revit HelloCodex add-in and a Python example used for testing Codex.

## Python Example
Run `python hello.py` to print a greeting.

## Revit Add-in
When run from **Add-Ins -> External Tools**, the add-in shows a task dialog that says "Hello Codex!".

## Build and Deploy
1. Ensure the `REVIT_API_PATH` environment variable points to the folder containing `RevitAPI.dll` and `RevitAPIUI.dll`.
2. Run `codex_build_deploy.bat`. The script compiles the project in **Release**/`x64` mode and copies the resulting `HelloCodex.dll` and manifest to `%AppData%\Autodesk\Revit\Addins\2022`.
3. Start Revit 2022 and run **HelloCodex** from **Add-Ins -> External Tools**.
