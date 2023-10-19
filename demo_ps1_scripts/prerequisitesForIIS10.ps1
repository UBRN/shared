# Define the minimum requirements for each component
$minDotNetVersion = "4.6"
$minPowerShellVersion = "4.0"
$minWMFVersion = "5.0"
$minASPNETVersion = "4.7"
$minWebDeployVersion = "3.6"
$minURLRewriteVersion = "2.1"
$minARRVersion = "3.1"

# Define the registry paths and names for each component
$dotNetRegPath = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
$dotNetRegName = "Release"
$powerShellRegPath = "HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine"
$powerShellRegName = "PowerShellVersion"
$wmfRegPath = "HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine"
$wmfRegName = "PSCompatibleVersion"
$aspNetRegPath = "HKLM:\SOFTWARE\Microsoft\ASP.NET\4.0.30319.0"
$aspNetRegName = "DllFullBuildNumber"
$webDeployRegPath = "HKLM:\SOFTWARE\Microsoft\IIS Extensions\MSDeploy\3"
$webDeployRegName = "DisplayVersion"
$urlRewriteRegPath = "HKLM:\SOFTWARE\Microsoft\IIS Extensions\UrlRewrite"
$urlRewriteRegName = "DisplayVersion"
$arrRegPath = "HKLM:\SOFTWARE\Microsoft\Application Request Routing"
$arrRegName = "DisplayVersion"

# Define the download links for each component based on the OS version
$osVersion = (Get-WmiObject -Class Win32_OperatingSystem).Caption
switch ($osVersion) {
    "Microsoft Windows Server 2008 R2" {
        $dotNetLink = "[Download .NET Framework 4.6]"
        $powerShellLink = "[Download Windows PowerShell 4.0]"
        $wmfLink = "[Download Windows Management Framework 5.0]"
        $aspNetLink = "[Download ASP.NET 4.7]"
        $webDeployLink = "[Download Web Deploy 3.6]"
        $urlRewriteLink = "[Download URL Rewrite 2.1]"
        $arrLink = "[Download Application Request Routing 3.1]"
    }
    "Microsoft Windows Server 2012 R2" {
        $dotNetLink = "[Download .NET Framework 4.6]"
        $powerShellLink = "[Download Windows PowerShell 4.0]"
        $wmfLink = "[Download Windows Management Framework 5.0]"
        $aspNetLink = "[Download ASP.NET 4.7]"
        $webDeployLink = "[Download Web Deploy 3.6]"
        $urlRewriteLink = "[Download URL Rewrite 2.1]"
        $arrLink = "[Download Application Request Routing 3.1]"
    }
    "Microsoft Windows Server 2016" {
        $dotNetLink = "[Download .NET Framework 4.6]"
        $powerShellLink = "Windows PowerShell 4.0 is included in Windows Server 2016"
        $wmfLink = "Windows Management Framework 5.0 is included in Windows Server 2016"
        $aspNetLink = "ASP.NET 4.7 is included in Windows Server 2016"
        $webDeployLink = "[Download Web Deploy 3.6]"
        $urlRewriteLink = "[Download URL Rewrite 2.1]"
        $arrLink = "[Download Application Request Routing 3.1]"
    }
    default {
        Write-Error "Unsupported operating system: $osVersion"
        break
    }
}

# Define the HTML report file name and path
$reportFile = "VMRequirementsReport.html"
$reportPath = Join-Path -Path $PSScriptRoot -ChildPath $reportFile

# Define the log file name and path
$logFile = "VMRequirementsLog.txt"
$logPath = Join-Path -Path $PSScriptRoot -ChildPath $logFile

# Create a function to write to the log file
function Write-Log {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Add-Content -Path $logPath -Value "$(Get-Date) - $Message"
}

# Create a function to get the version of a component from the registry
function Get-Version {
    param (
        [Parameter(Mandatory=$true)]
        [string]$RegPath,
        [Parameter(Mandatory=$true)]
        [string]$RegName
    )
    try {
        $regValue = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction Stop
        return $regValue.$RegName
    }
    catch {
        Write-Error $_.Exception.Message
        Write-Log $_.Exception.Message
        return $null
    }
}

# Create a function to compare two version strings
function Compare-Version {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Version1,
        [Parameter(Mandatory=$true)]
        [string]$Version2
    )
    # Split the version strings by dots and convert to integers
    $v1 = $Version1.Split(".") | ForEach-Object { [int]$_ }
    $v2 = $Version2.Split(".") | ForEach-Object { [int]$_ }

    # Compare each segment of the version strings
    for ($i = 0; $i -lt [Math]::Max($v1.Length, $v2.Length); $i++) {
        # If one version string has more segments than the other, assume zero for the missing segments
        if ($i -ge $v1.Length) { $v1 += 0 }
        if ($i -ge $v2.Length) { $v2 += 0 }

        # If the segments are not equal, return the comparison result
        if ($v1[$i] -ne $v2[$i]) {
            return $v1[$i].CompareTo($v2[$i])
        }
    }

    # If all segments are equal, return zero
    return 0
}

# Create a function to check if a requirement is met and output a message
function Check-Requirement {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Component,
        [Parameter(Mandatory=$true)]
        [string]$CurrentVersion,
        [Parameter(Mandatory=$true)]
        [string]$MinVersion,
        [Parameter(Mandatory=$true)]
        [string]$DownloadLink
    )
    # Compare the current version with the minimum version
    $result = Compare-Version -Version1 $CurrentVersion -Version2 $MinVersion

    # If the current version is greater than or equal to the minimum version, output a success message
    if ($result -ge 0) {
        Write-Host "$Component requirement is met: Current version is $CurrentVersion, minimum version is $MinVersion"
        Write-Log "$Component requirement is met: Current version is $CurrentVersion, minimum version is $MinVersion"
        
        # Return an HTML table row with a green background color and a check mark icon
        return "<tr style='background-color: lightgreen;'><td>$Component</td><td>$CurrentVersion</td><td>$MinVersion</td><td><img src='https://cdn-icons-png.flaticon.com/512/390/390973.png' width='24' height='24'></td></tr>"
    }
    # If the current version is less than the minimum version, output a failure message and a recommendation
    else {
        Write-Host "$Component requirement is not met: Current version is $CurrentVersion, minimum version is $MinVersion"
        Write-Host "Please update your $Component by following this link: $DownloadLink"
        Write-Log "$Component requirement is not met: Current version is $CurrentVersion, minimum version is $MinVersion"
        Write-Log "Please update your $Component by following this link: $DownloadLink"

        # Return an HTML table row with a red background color and a cross mark# Define the minimum requirements for each component
$minDotNetVersion = "4.6"
$minPowerShellVersion = "4.0"
$minWMFVersion = "5.0"
$minASPNETVersion = "4.7"
$minWebDeployVersion = "3.6"
$minURLRewriteVersion = "2.1"
$minARRVersion = "3.1"

# Define the registry paths and names for each component
$dotNetRegPath = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
$dotNetRegName = "Release"
$powerShellRegPath = "HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine"
$powerShellRegName = "PowerShellVersion"
$wmfRegPath = "HKLM:\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine"
$wmfRegName = "PSCompatibleVersion"
$aspNetRegPath = "HKLM:\SOFTWARE\Microsoft\ASP.NET\4.0.30319.0"
$aspNetRegName = "DllFullBuildNumber"
$webDeployRegPath = "HKLM:\SOFTWARE\Microsoft\IIS Extensions\MSDeploy\3"
$webDeployRegName = "DisplayVersion"
$urlRewriteRegPath = "HKLM:\SOFTWARE\Microsoft\IIS Extensions\UrlRewrite"
$urlRewriteRegName = "DisplayVersion"
$arrRegPath = "HKLM:\SOFTWARE\Microsoft\Application Request Routing"
$arrRegName = "DisplayVersion"

# Define the download links for each component based on the OS version
$osVersion = (Get-WmiObject -Class Win32_OperatingSystem).Caption
switch ($osVersion) {
    "Microsoft Windows Server 2008 R2" {
        $dotNetLink = "[Download .NET Framework 4.6]"
        $powerShellLink = "[Download Windows PowerShell 4.0]"
        $wmfLink = "[Download Windows Management Framework 5.0]"
        $aspNetLink = "[Download ASP.NET 4.7]"
        $webDeployLink = "[Download Web Deploy 3.6]"
        $urlRewriteLink = "[Download URL Rewrite 2.1]"
        $arrLink = "[Download Application Request Routing 3.1]"
    }
    "Microsoft Windows Server 2012 R2" {
        $dotNetLink = "[Download .NET Framework 4.6]"
        $powerShellLink = "[Download Windows PowerShell 4.0]"
        $wmfLink = "[Download Windows Management Framework 5.0]"
        $aspNetLink = "[Download ASP.NET 4.7]"
        $webDeployLink = "[Download Web Deploy 3.6]"
        $urlRewriteLink = "[Download URL Rewrite 2.1]"
        $arrLink = "[Download Application Request Routing 3.1]"
    }
    "Microsoft Windows Server 2016" {
        $dotNetLink = "[Download .NET Framework 4.6]"
        $powerShellLink = "Windows PowerShell 4.0 is included in Windows Server 2016"
        $wmfLink = "Windows Management Framework 5.0 is included in Windows Server 2016"
        $aspNetLink = "ASP.NET 4.7 is included in Windows Server 2016"
        $webDeployLink = "[Download Web Deploy 3.6]"
        $urlRewriteLink = "[Download URL Rewrite 2.1]"
        $arrLink = "[Download Application Request Routing 3.1]"
    }
    default {
        Write-Error "Unsupported operating system: $osVersion"
        break
    }
}

# Define the HTML report file name and path
$reportFile = "VMRequirementsReport.html"
$reportPath = Join-Path -Path $PSScriptRoot -ChildPath $reportFile

# Define the log file name and path
$logFile = "VMRequirementsLog.txt"
$logPath = Join-Path -Path $PSScriptRoot -ChildPath $logFile

# Create a function to write to the log file
function Write-Log {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Add-Content -Path $logPath -Value "$(Get-Date) - $Message"
}

# Create a function to get the version of a component from the registry
function Get-Version {
    param (
        [Parameter(Mandatory=$true)]
        [string]$RegPath,
        [Parameter(Mandatory=$true)]
        [string]$RegName
    )
    try {
        $regValue = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction Stop
        return $regValue.$RegName
    }
    catch {
        Write-Error $_.Exception.Message
        Write-Log $_.Exception.Message
        return $null
    }
}

# Create a function to compare two version strings
function Compare-Version {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Version1,
        [Parameter(Mandatory=$true)]
        [string]$Version2
    )
    # Split the version strings by dots and convert to integers
    $v1 = $Version1.Split(".") | ForEach-Object { [int]$_ }
    $v2 = $Version2.Split(".") | ForEach-Object { [int]$_ }

    # Compare each segment of the version strings
    for ($i = 0; $i -lt [Math]::Max($v1.Length, $v2.Length); $i++) {
        # If one version string has more segments than the other, assume zero for the missing segments
        if ($i -ge $v1.Length) { $v1 += 0 }
        if ($i -ge $v2.Length) { $v2 += 0 }

        # If the segments are not equal, return the comparison result
        if ($v1[$i] -ne $v2[$i]) {
            return $v1[$i].CompareTo($v2[$i])
        }
    }

    # If all segments are equal, return zero
    return 0
}

# Create a function to check if a requirement is met and output a message
function Check-Requirement {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Component,
        [Parameter(Mandatory=$true)]
        [string]$CurrentVersion,
        [Parameter(Mandatory=$true)]
        [string]$MinVersion,
        [Parameter(Mandatory=$true)]
        [string]$DownloadLink
    )
    # Compare the current version with the minimum version
    $result = Compare-Version -Version1 $CurrentVersion -Version2 $MinVersion

    # If the current version is greater than or equal to the minimum version, output a success message
    if ($result -ge 0) {
        Write-Host "$Component requirement is met: Current version is $CurrentVersion, minimum version is $MinVersion"
        Write-Log "$Component requirement is met: Current version is $CurrentVersion, minimum version is $MinVersion"
        
        # Return an HTML table row with a green background color and a check mark icon
        return "<tr style='background-color: lightgreen;'><td>$Component</td><td>$CurrentVersion</td><td>$MinVersion</td><td><img src='https://cdn-icons-png.flaticon.com/512/390/390973.png' width='24' height='24'></td></tr>"
    }
    # If the current version is less than the minimum version, output a failure message and a recommendation
    else {
        Write-Host "$Component requirement is not met: Current version is $CurrentVersion, minimum version is $MinVersion"
        Write-Host "Please update your $Component by following this link: $DownloadLink"
        Write-Log "$Component requirement is not met: Current version is $CurrentVersion, minimum version is $MinVersion"
        Write-Log "Please update your $Component by following this link: $DownloadLink"

        # Return an HTML table row with a red background color and a cross mark icon
        return "<tr style='background-color: lightcoral;'><td>$Component</td><td>$CurrentVersion</td><td>$MinVersion</td><td><img src='https://cdn-icons-png.flaticon.com/512/1828/1828665.png' width='24' height='24'></td></tr>"
    }
}

# Create an HTML report header with some basic information and styles
$reportHeader = @"
<html>
<head>
<title>VM Requirements Report</title>
<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
  text-align: left;
}
</style>
</head>
<body>
<h1>VM Requirements Report</h1>
<p>This report shows the results of checking the local