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
echo   [1 of 3]  Firebase
echo  ==========================================================
echo.
call "%FB%" deploy --only hosting --project brokenheart-quest
echo.
echo  ==========================================================
echo   [2 of 3]  Surge
echo  ==========================================================
echo.
call "%APPDATA%\npm\surge.cmd" "%~dp0public" kiravexia.surge.sh
echo.
echo  ==========================================================
echo   [3 of 3]  Render
echo  ==========================================================
echo.
git add -A
git -c commit.gpgsign=false commit -m "Update page" 2>nul || echo  (no changes to send)
git push origin main
echo.
echo  ==========================================================
echo   ALL THREE SITES:
echo     https://kiravexia.web.app        instant
echo     https://kiravexia.surge.sh       instant
echo     https://kiravexia.onrender.com   1-2 minutes
echo.
echo   Press Ctrl+F5 in your browser to see the new version.
echo  ==========================================================
echo.
pause
