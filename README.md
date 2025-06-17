# 20250616

This repository contains a minimal Revit HelloCodex add-in and a Python example used for testing Codex.

## Python Example
Run `python hello.py` to print a greeting.

## Revit Add-in
When run from **Add-Ins -> External Tools**, the add-in shows a task dialog that says "Hello Codex!".

### Build and Deploy
1. Set the `REVIT_API_PATH` environment variable to the folder that contains
   `RevitAPI.dll` and `RevitAPIUI.dll`.
2. Open a **Developer Command Prompt for VS 2022** and run
   `codex_build_deploy.bat` from the repository root (for example,
   `D:\02 Code\07 Revit Addin\20250616`).
   The script invokes *msbuild* on `RevitAddin\RevitAddin.csproj` in
   **Release**/`x64` mode. The resulting `HelloCodex.dll` is copied together
   with the `HelloCodex.addin` manifest to
   `C:\Users\Administrator\AppData\Roaming\Autodesk\Revit\Addins\2022`.
3. Start Revit 2022 and choose **HelloCodex** from **Add-Ins -> External Tools**.
