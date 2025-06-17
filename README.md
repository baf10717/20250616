# Revit HelloCodex Add-in

This repository contains a minimal Revit add-in. When run from **Add-Ins -> External Tools**, it displays a task dialog that says "Hello Codex!".

## Build and Deploy
1. Ensure the `REVIT_API_PATH` environment variable points to the folder containing `RevitAPI.dll` and `RevitAPIUI.dll`.
2. Run `build_and_deploy.bat`. The script compiles the project in **Release**/`x64` mode and copies the resulting `HelloCodex.dll` and manifest to `%AppData%\Autodesk\Revit\Addins\2022`.
3. Start Revit 2022 and run **HelloCodex** from **Add-Ins -> External Tools**.
