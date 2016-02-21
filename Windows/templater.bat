@echo off

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
    echo or more versioning and rendering jobs with Templater's CLI.
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

::For safe measure, copy the installed jsxbin to the current folder
copy /Y "%APP_DIR%\%PANELS%\Templater 2.jsxbin" "%CD%\Templater 2.jsxbin"

::Run After Effects along with the Templater 2 file
"%APP_DIR%\afterfx" -r %MULTI% %USE_UI% "%CD%\Templater 2.jsxbin"
