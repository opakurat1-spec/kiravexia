@echo off
title Publishing Kiravexia
cd /d "%~dp0"
set "PATH=%PATH%;C:\Program Files\GitHub CLI"
set "FB="
where firebase >nul 2>&1 && set "FB=firebase"
if not defined FB if exist "%APPDATA%\npm\firebase.cmd" set "FB=%APPDATA%\npm\firebase.cmd"
if not defined FB (
  echo.
  echo   The publishing tool is not installed.
  echo   Run SETUP-ONCE in the brokenheart-quest folder first.
  echo.
  pause
  exit /b 1
)
echo.
echo  ==========================================================
echo   [1 of 2]  Publishing to Firebase ...
echo  ==========================================================
echo.
call "%FB%" deploy --only hosting --project brokenheart-quest
echo.
echo  ==========================================================
echo   [2 of 2]  Publishing to Render ...
echo  ==========================================================
echo.
git add -A
git -c commit.gpgsign=false commit -m "Update page" 2>nul || echo  (no changes to send)
git push origin main
echo.
echo  ==========================================================
echo   BOTH SITES:
echo     https://kiravexia.web.app        (updates instantly)
echo     https://kiravexia.onrender.com   (takes 1-2 minutes)
echo.
echo   Press Ctrl+F5 in your browser to see the new version.
echo   If you see an error above, screenshot it for Claude.
echo  ==========================================================
echo.
pause
