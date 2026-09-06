@echo off
title Publishing Kiravexia
cd /d "%~dp0"
set "PATH=%PATH%;C:\Program Files\GitHub CLI"
set "HIST=%~dp0publish-history.txt"
set "FB=%APPDATA%\npm\firebase.cmd"
set "SG=%APPDATA%\npm\surge.cmd"
set "VC=%APPDATA%\npm\vercel.cmd"

echo [%date% %time%] ---- STARTED ---- >> "%HIST%"

if not exist "%FB%" echo   firebase MISSING >> "%HIST%"
if exist "%FB%" echo   firebase ok >> "%HIST%"
if not exist "%SG%" echo   surge MISSING >> "%HIST%"
if exist "%SG%" echo   surge ok >> "%HIST%"
if not exist "%VC%" echo   vercel MISSING >> "%HIST%"
if exist "%VC%" echo   vercel ok >> "%HIST%"

if not exist "%SG%" echo   Installing Surge, one moment...
if not exist "%SG%" call npm install -g surge
if not exist "%VC%" echo   Installing Vercel, one moment...
if not exist "%VC%" call npm install -g vercel

echo.
echo  ==========================================================
echo   [1 of 4]  Firebase
echo  ==========================================================
echo.
echo [%date% %time%] step 1 firebase >> "%HIST%"
call "%FB%" deploy --only hosting --project brokenheart-quest
echo [%date% %time%]   firebase exit=%ERRORLEVEL% >> "%HIST%"

echo.
echo  ==========================================================
echo   [2 of 4]  Surge
echo  ==========================================================
echo.
echo [%date% %time%] step 2 surge >> "%HIST%"
call "%SG%" "%~dp0public" kiravexia.surge.sh
echo [%date% %time%]   surge exit=%ERRORLEVEL% >> "%HIST%"

echo.
echo  ==========================================================
echo   [3 of 4]  Vercel
echo  ==========================================================
echo.
echo [%date% %time%] step 3 vercel >> "%HIST%"
call "%VC%" deploy --prod --yes
echo [%date% %time%]   vercel exit=%ERRORLEVEL% >> "%HIST%"

echo.
echo  ==========================================================
echo   [4 of 4]  Render
echo  ==========================================================
echo.
echo [%date% %time%] step 4 render >> "%HIST%"
git add -A
git -c commit.gpgsign=false commit -m "Update page"
git push origin main
echo [%date% %time%]   render exit=%ERRORLEVEL% >> "%HIST%"

echo.
echo  ==========================================================
echo    https://kiravexia.web.app        instant
echo    https://kiravexia.surge.sh       instant
echo    https://kiravexia.vercel.app   instant
echo    https://kiravexia.onrender.com   1-2 minutes
echo.
echo    Press Ctrl+F5 in your browser to see the new version.
echo  ==========================================================
echo.
echo [%date% %time%] ---- FINISHED ---- >> "%HIST%"
pause
