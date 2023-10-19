@echo off
set /p ClientDNS="Enter Client DNS: "
net use \\%ClientDNS%\C$ /user:%username% %password%
if %errorlevel% neq 0 (
    echo Unable to connect to the specified client.
) else (
    echo Connected to %ClientDNS%. Opening C$ directory...
    explorer \\%ClientDNS%\C$
)
net use \\%ClientDNS%\C$ /delete