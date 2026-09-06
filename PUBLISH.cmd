@echo off
title Publishing Kiravexia
cd /d "%~dp0"
set "PATH=%PATH%;C:\Program Files\GitHub CLI"
set "HIST=%~dp0publish-history.txt"
set "FB=%APPDATA%\npm\firebase.cmd"
set "SG=%APPDATA%\npm\surge.cmd"
set "VC=%APPDATA%\npm\vercel.cmd"
set "NT=%APPDATA%\npm\netlify.cmd"

echo [%date% %time%] ---- STARTED ---- >> "%HIST%"
if exist "%FB%" (echo   firebase ok >> "%HIST%") else (echo   firebase MISSING >> "%HIST%")
if exist "%SG%" (echo   surge ok >> "%HIST%") else (echo   surge MISSING >> "%HIST%")
if exist "%VC%" (echo   vercel ok >> "%HIST%") else (echo   vercel MISSING >> "%HIST%")
if exist "%NT%" (echo   netlify ok >> "%HIST%") else (echo   netlify MISSING >> "%HIST%")

if not exist "%SG%" echo   Installing Surge...
if not exist "%SG%" call npm install -g surge
if not exist "%VC%" echo   Installing Vercel...
if not exist "%VC%" call npm install -g vercel
if not exist "%NT%" echo   Installing Netlify...
if not exist "%NT%" call npm install -g netlify-cli

echo.
echo  ===========  [1 of 5]  Firebase   from page-firebase  ===========
echo.
echo [%date% %time%] step 1 firebase >> "%HIST%"
call "%FB%" deploy --only hosting --project brokenheart-quest
echo [%date% %time%]   firebase exit=%ERRORLEVEL% >> "%HIST%"

echo.
echo  ===========  [2 of 5]  Surge      from page-surge  ===========
echo.
echo [%date% %time%] step 2 surge >> "%HIST%"
call "%SG%" "%~dp0page-surge" kiravexia.surge.sh
echo [%date% %time%]   surge exit=%ERRORLEVEL% >> "%HIST%"

echo.
echo  ===========  [3 of 5]  Vercel     from page-vercel  ===========
echo.
echo [%date% %time%] step 3 vercel >> "%HIST%"
call "%VC%" deploy --prod --yes
echo [%date% %time%]   vercel exit=%ERRORLEVEL% >> "%HIST%"

echo.
echo  ===========  [4 of 5]  Netlify    from page-netlify  ===========
echo.
echo [%date% %time%] step 4 netlify >> "%HIST%"
call "%NT%" deploy --prod --no-build --dir "%~dp0page-netlify" --site 92563d56-7ed7-41f9-899a-4a7b38d0f6e3
echo [%date% %time%]   netlify exit=%ERRORLEVEL% >> "%HIST%"

echo.
echo  ===========  [5 of 5]  Render     from page-render  ===========
echo.
echo [%date% %time%] step 5 render >> "%HIST%"
git add -A
git -c commit.gpgsign=false commit -m "Update page"
git push origin main
echo [%date% %time%]   render exit=%ERRORLEVEL% >> "%HIST%"

echo.
echo  ==========================================================
echo    https://kiravexia.web.app          instant
echo    https://kiravexia.surge.sh         instant
echo    https://kiravexia.vercel.app    instant
echo    https://kiravexia.netlify.app      instant
echo    https://kiravexia.onrender.com     1-2 minutes
echo.
echo    Press Ctrl+F5 in your browser to see the new version.
echo  ==========================================================
echo.
echo [%date% %time%] ---- FINISHED ---- >> "%HIST%"
pause
