@echo off

set "DIR_NAME=NoOneSurvivedServer"
set "DIR_DED=Dedicated"
set "STEAM_APP_ID=2329680"
set "STEAM_LOGIN_ANONYMOUS=anonymous"
set "DOWNLOAD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"

echo Welcome to the No One Survived server setup!
echo ..
echo This will download SteamCMD and No One Survived dedicated server files.
echo A folder called 'NoOneSurvivedServer' will be created, and all files will be downloaded to this location.
echo ..
echo This will also create the necessary shortcuts to start, update, and configure your server.

set /p create_folder=Do you want to create the NoOneSurvivedServer folder here? (Y/N):

if /i "%create_folder%"=="Y" (
mkdir NoOneSurvivedServer
) else (
echo Installation cancelled.
pause
exit
)

echo Installing SteamCMD...
mkdir "%~dp0%DIR_NAME%\SteamCMD"

Powershell.exe -Command "(New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%~dp0%DIR_NAME%\SteamCMD\steamcmd.zip')"
tar.exe -xzf "%~dp0%DIR_NAME%\SteamCMD\steamcmd.zip" -C "%~dp0%DIR_NAME%\SteamCMD"

echo Installing No One Survived dedicated server...
mkdir "%~dp0%DIR_NAME%\%DIR_DED%"
"%~dp0%DIR_NAME%\SteamCMD\steamcmd.exe" +force_install_dir "%~dp0%DIR_NAME%\%DIR_DED%"  +login %STEAM_LOGIN_ANONYMOUS% +app_update %STEAM_APP_ID% validate +quit

echo Creating Start Server shortcut...
set "TARGET=%~dp0%DIR_NAME%\%DIR_DED%\WRSHServer.exe"
set "ARGS=-server -log"
set "ICON=%~dp0%DIR_NAME%\%DIR_DED%\WRSHServer.exe"
set "LINK=%~dp0%DIR_NAME%\Start Server.lnk"
Powershell.exe -command "$s=(New-Object -com WScript.Shell).CreateShortcut('%LINK%');$s.TargetPath='%TARGET%';$s.Arguments='%ARGS%';$s.IconLocation='%ICON%';$s.Save()"

echo Creating Configure Server shortcut...
set "TARGET=%~dp0%DIR_NAME%\%DIR_DED%\WRSH\Saved\Config\WindowsServer\Game.ini"
set "LINK=%~dp0%DIR_NAME%\Configure Server.lnk"
Powershell.exe -command "$s=(New-Object -com WScript.Shell).CreateShortcut('%LINK%');$s.TargetPath='%TARGET%';$s.Save()"

echo Creating Update Server batch file...
set "UPDATE_FILE=%~dp0%DIR_NAME%\Update_Server.bat"
echo @echo off > "%UPDATE_FILE%"
echo "%~dp0%DIR_NAME%\SteamCMD\steamcmd.exe" +force_install_dir "%~dp0%DIR_NAME%\%DIR_DED%"  +login %STEAM_LOGIN_ANONYMOUS% +app_update %STEAM_APP_ID% validate +quit >> "%UPDATE_FILE%"

echo Installation complete.

echo Creating Help.txt file...
set "HELP_FILE=%~dp0%DIR_NAME%\Help.txt"
echo To start the No One Survived server, run the "Start Server.lnk" shortcut in this folder. Make sure to open the following ports on your router and point them to the IP of your server: UDP 7777, 27105. To update the server, run the "Update_Server.bat" file in this folder.>"%HELP_FILE%"

echo Opening NoOneSurvivedServer folder...
start "" "%~dp0%DIR_NAME%"
