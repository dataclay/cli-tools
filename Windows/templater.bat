@echo off
setlocal ENABLEDELAYEDEXPANSION

::Get command line parameters
if "%~1"=="" (set APP_VER="null") else (set APP_VER=%1)
if "%~2"=="" (set USE_UI="-noui") else (set USE_UI=" ")
if "%~3"=="" (set MULTI=" ") else (set MULTI="-m")

::After Effects Application Directories
SET APP_DIR=C:\Program Files\Adobe\Adobe After Effects %~1\Support Files
SET PANELS=Scripts\ScriptUI Panels

::If no command line arguments, then print usage
set or_=
if %APP_VER%=="CC 2015" set or_=true
if %APP_VER%=="CC 2014" set or_=true
if %APP_VER%=="CC" set or_=true
if %APP_VER%=="CS6" set or_=true
if %APP_VER%=="CS5.5" set or_=true
if %APP_VER%=="CS5" set or_=true
if not defined or_ (
    echo.
    echo Usage:
    echo    templater [version] [ui] [-m]
    echo.
    echo Version options:
    echo     'CC 2015' 'CC 2014' 'CC' 'CS6 'CS5.5' CS5'
    echo.
    echo Include option '-m' to launch After Effects as a new, separate,
    echo process. This is useful if you want to simultaneously execute two
    echo or more versioning jobs with Templater's CLI.
    echo.
    echo Include option 'ui' to launch with a GUI
    echo.
    echo Examples:
    echo     To launch CC 2015 without a GUI : templater "CC 2015"
    echo     To launch CC 2015 with a GUI    : templater "CC 2015" ui
    echo     To launch CS5 without a GUI     : templater "CS5"
    echo     To launch CS5 with a GUI        : templater "CS5" ui
    exit /B
)

::Verify the templater-options.json file exists in the current directory
if not exist "%CD%\templater-options.json" (
  echo Templater CLI Error: No cli configuration file found
  echo.
  echo Ensure "templater-options.json" file exists in =^>
  echo "%CD%" 
  echo.
  echo See you next time :^)
  echo.
  exit /B
)

::Get log location from templater-options file.
for /f "tokens=1,2,*" %%a in (' find ":" ^< "templater-options.json" ') do (
  if %%a=="log_location": (
    set log_loc=%%~b%%~c
    call:GetLogLoc log_path "%log_loc%"
  )
)

echo.
echo - - - - - - - - - - - - - -
echo.
echo Templater 2 CLI Configuration (templater-options.json)
echo.
echo Configuration loaded from =^>
echo %CD%\templater-options.json
echo.
echo log_location : %log_path%
echo.
echo.

echo Now launching Adobe After Effects

::For safe measure, copy the installed jsxbin to the current folder
copy /Y "%APP_DIR%\%PANELS%\Templater 2.jsxbin" "%CD%\Templater 2.jsxbin"

::Run After Effects along with the Templater 2 file
"%APP_DIR%\afterfx" -r %MULTI% %USE_UI% "%CD%\Templater 2.jsxbin"

echo.
echo.
echo Done with After Effects processing.  See log files below for more information =^>
echo.
dir "%log_path%"

if exist "%log_path%\templater.log" (
   for /F "delims=" %%a in (%log_path%\templater.log) do (
     set "previous=!last!"
     set "last=%%a"
   )
 echo.
 echo.
 echo LAST LOGGED MESSAGE =^>
 echo.
 echo !previous!
 echo.
 echo.
)

if exist "%log_path%\templater.err" (
   for /F "delims=" %%a in (%log_path%\templater.err) do (
     set "previous=!last!"
     set "last=%%a"
   )
 echo LAST REPORTED ERROR =^>
 echo.
 echo !previous!
 echo.
 echo.
)

:GetLogLoc
 set #=%~2
 set log_path=%#:\\=\%
GOTO :EOF


echo.
echo.
