@echo off
setlocal

REM Set your domain, username, and password
set "domain=YourDomain"
set "username=YourUsername"
set "password=YourPassword"

REM Get the ClientDNS from the user
set /p "clientDNS=Enter ClientDNS: "

REM Use net use to map the C$ share and open File Explorer
net use \\%clientDNS%\C$ /user:%domain%\%username% %password%
start "" "\\%clientDNS%\C$"

REM Clean up the mapped drive
net use \\%clientDNS%\C$ /delete

endlocal