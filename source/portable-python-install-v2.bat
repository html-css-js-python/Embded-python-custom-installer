@echo off

set "dir=%~1"

if "%dir%"=="" (
	echo [31mPlease enter download directory![0m
	exit /b
)

if not exist "%dir%" (
	echo [31mError! Entered directory is invalid![0m
	echo [31mPlease enter valid download directory![0m
	exit /b
)

set /p "cho=Do you want to install portable python? (y/n): "

if /i not "%cho%"=="y" (
	exit /b
)

:::::::::::::::::::::: Downloading ::::::::::::::::::::::

cd /d "%dir%" || exit /b

echo [94mDownloading data...[0m

:: Download embded Python 3.12.0
curl -o python.zip https://www.python.org/ftp/python/3.12.0/python-3.12.0-embed-amd64.zip > nul

if %errorlevel% neq 0 (
    echo [31mError in downloading: python.zip[0m
	exit /b
) else (
    echo [95mFile downloaded: python.zip[0m
)

:: Download pip installer
curl -o get-pip.py https://bootstrap.pypa.io/get-pip.py > nul

if %errorlevel% neq 0 (
    echo [31mError in downloading: get-pip.py[0m
	exit /b
) else (
    echo [95mFile downloaded: get-pip.py[0m
)

:::::::::::::::::::::: Unpacking Files ::::::::::::::::::::::

echo [94mUnpacking files...[0m

:: Unpack python.zip
tar -xf python.zip > nul

if %errorlevel% neq 0 (
    echo [31mError in unpacking: python.zip[0m
	exit /b
) else (
    echo [95mFile unpacked: python.zip[0m
)

:::::::::::::::::::::: Configuring Python ::::::::::::::::::::::

echo [94mConfiguring Python...[0m

:: Uncommenting "import site" in python312._pth

set "file=python312._pth"
set "tmp=temp.txt"

(for /f "usebackq delims=" %%A in ("%file%") do (
    set "line=%%A"
    setlocal enabledelayedexpansion

    if "!line!"=="#import site" (
        echo import site
    ) else (
        echo !line!
    )

    endlocal
)) > "%tmp%"

move /y "%tmp%" "%file%" > nul

if %errorlevel% neq 0 (
    echo [31mError in configuring: %file%[0m
	exit /b
) else (
    echo [95mFile configured: %file%[0m
)

:::::::::::::::::::::: Installing pip ::::::::::::::::::::::

echo [94mInstalling pip...[0m

:: Installing pip
.\python.exe get-pip.py --no-warn-script-location > nul

if %errorlevel% neq 0 (
    echo [31mError in installing: pip[0m
	exit /b
) else (
    echo [95mModule installed: pip[0m
)

:::::::::::::::::::::: Fixing pip ::::::::::::::::::::::

echo [94mFixing pip...[0m

:: Fix pip
.\python.exe -m pip install --upgrade pip --no-warn-script-location > nul

if %errorlevel% neq 0 (
    echo [31mError in fixing: pip[0m
	exit /b
) else (
    echo [95mModule fixed: pip[0m
)

:::::::::::::::::::::: Fixing setuptools and wheel ::::::::::::::::::::::

echo [94mInstalling setuptools and wheel...[0m

:: Install setuptools and wheel
.\python.exe -m pip install setuptools wheel --no-warn-script-location > nul

:: Upgrade setuptools and wheel
.\python.exe -m pip install --upgrade setuptools wheel > nul

if %errorlevel% neq 0 (
    echo [31mError in fixing: setuptools, wheel[0m
	exit /b
) else (
    echo [95mModules installed: setuptools, wheel[0m
)

:::::::::::::::::::::: Installing virtualenv ::::::::::::::::::::::

echo [94mInstalling virtualenv...[0m

:: Installing virtualenv
.\python.exe -m pip install virtualenv --no-warn-script-location > nul

if %errorlevel% neq 0 (
    echo [31mError in installing: virtualenv[0m
	exit /b
) else (
    echo [95mModule installed: virtualenv[0m
)

:::::::::::::::::::::: Creating project folder ::::::::::::::::::::::

echo [94mCreating "project" folder...[0m

:: Creating folder
mkdir project

if %errorlevel% neq 0 (
    echo [31mError in creating: project[0m
	exit /b
) else (
    echo [95mFolder created: project[0m
)

:: Make venv
.\python.exe -m virtualenv project/venv

if %errorlevel% neq 0 (
    echo [31mError in making venv.[0m
	exit /b
) else (
    echo [95mVenv created.[0m
)

:::::::::::::::::::::: End code ::::::::::::::::::::::

echo [92mPortable python installed succesfully![0m
echo [96mThank you![0m
echo.

pause

cd project

:: Activate venv
call venv\Scripts\activate.bat

cls