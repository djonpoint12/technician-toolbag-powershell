#Requires -Version 5.1
<#
.SYNOPSIS
    Automated Health Audit for Windows Laptops

.DESCRIPTION
    Generates a detailed, readable battery health report (HTML) for local Windows laptops.
    For IT/Techs: Full capacity, cycle count, health %, history, and recent usage in one file.

.AUTHOR
    Chase Flores | github.com/djonpoint12 | chaseflores.vercel.app
#>

[CmdletBinding()]
param()

begin {
    # Ensure admin rights
    function Test-IsElevated {
        $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $p = New-Object System.Security.Principal.WindowsPrincipal($id)
        $p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    if (!(Test-IsElevated)) {
        Write-Host "[Error] Please run as Administrator." -ForegroundColor Red
        exit 1
    }

    # Detect battery
    try {
        $CurrentBattery = Get-CimInstance -ClassName Win32_Battery -ErrorAction Stop
    } catch {
        Write-Host "[Error] No battery detected on this device." -ForegroundColor Yellow
        exit 1
    }
    if (!$CurrentBattery) {
        Write-Host "[Error] No battery detected on this device." -ForegroundColor Yellow
        exit 1
    }

    # Generate battery report XML
    $BatteryReport = "$env:TEMP\batteryhealthreport.xml"
    $null = Start-Process -FilePath "$env:SystemRoot\System32\powercfg.exe" `
        -ArgumentList "/batteryreport", "/xml", "/output", $BatteryReport `
        -Wait -WindowStyle Hidden

    if (!(Test-Path $BatteryReport)) {
        Write-Host "[Error] Could not create battery report." -ForegroundColor Red
        exit 1
    }

    [xml]$BatteryHealthReport = Get-Content $BatteryReport
    Remove-Item $BatteryReport -Force

    # Parse system info
    $sys = $BatteryHealthReport.BatteryReport.SystemInformation
    $ReportTime = (Get-Date $BatteryHealthReport.BatteryReport.ReportInformation.LocalScanTime)
    $SystemInformation = [PSCustomObject]@{
        ReportTime        = $ReportTime.ToString('g')
        SystemProductName = "$($sys.SystemManufacturer) $($sys.SystemProductName)"
        BIOS              = "$($sys.BIOSVersion) $($sys.BIOSDate)"
        OSBuild           = $sys.OSBuild
        ConnectedStandby  = if ($sys.ConnectedStandby -eq 1) { "Supported" } else { "Not Supported" }
    }

    # Batteries
    $Batteries = @()
    foreach ($b in $BatteryHealthReport.BatteryReport.Batteries.Battery) {
        $health = if ($b.DesignCapacity -and $b.FullChargeCapacity) {
            [math]::Round(100 * [double]$b.FullChargeCapacity / [double]$b.DesignCapacity, 2)
        } else { "-" }
        $Batteries += [PSCustomObject]@{
            Name        = $b.Id
            Manufacturer= $b.Manufacturer
            SerialNumber= $b.SerialNumber
            Chemistry   = $b.Chemistry
            HealthPct   = "$health`%"
            DesignCap   = "$($b.DesignCapacity) mWh"
            FullCharge  = "$($b.FullChargeCapacity) mWh"
            CycleCount  = if ($b.CycleCount) { $b.CycleCount } else { "-" }
        }
    }

    # Recent usage
    $RecentUsage = @()
    foreach ($r in $BatteryHealthReport.BatteryReport.RecentUsage.UsageEntry) {
        if ($r.EntryType -eq "ReportGenerated") { continue }
        $RecentUsage += [PSCustomObject]@{
            Time        = (Get-Date $r.LocalTimeStamp).ToString('g')
            State       = $r.EntryType
            Source      = if ($r.AC -eq 1) { "AC" } elseif ($r.AC -eq 0) { "Battery" } else { "-" }
            PercentRem  = if ($r.FullChargeCapacity) { [math]::Round(100 * $r.ChargeCapacity / $r.FullChargeCapacity, 2) } else { "-" }
            mWhRem      = "$($r.ChargeCapacity) mWh"
        }
    }

    # Output HTML
    $ts = Get-Date -Format "yyyyMMdd_HHmmss"
    $htmlPath = Join-Path $PSScriptRoot "BatteryReport_${ts}.html"
    $header = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <title>Automated Health Audit for Windows Laptops</title>
    <style>
        body { font-family: Segoe UI, Arial, sans-serif; margin:40px; }
        h1 { color:#2563eb; }
        .meta { color: #888; margin-bottom: 24px;}
        table { border-collapse: collapse; width: 100%; margin-top: 16px;}
        th, td { border: 1px solid #e5e7eb; padding: 10px 12px; }
        th { background: #f3f4f6; }
        tr:nth-child(even) { background: #f8fafc; }
    </style>
</head>
<body>
    <h1>Automated Health Audit for Windows Laptops</h1>
    <div class='meta'>By Chase Flores | <a href='https://github.com/djonpoint12'>github.com/djonpoint12</a> | <a href='https://chaseflores.vercel.app'>chaseflores.vercel.app</a><br>Generated: $($SystemInformation.ReportTime)</div>
"@

    $sysInfoHtml = "<h2>System Information</h2><table>"
    foreach ($p in $SystemInformation.PSObject.Properties) {
        $sysInfoHtml += "<tr><th>$($p.Name)</th><td>$($p.Value)</td></tr>"
    }
    $sysInfoHtml += "</table>"

    $batHtml = "<h2>Batteries</h2><table><tr>"
    $cols = $Batteries[0].PSObject.Properties | Select-Object -ExpandProperty Name
    foreach ($c in $cols) { $batHtml += "<th>$c</th>" }
    $batHtml += "</tr>"
    foreach ($b in $Batteries) {
        $batHtml += "<tr>"
        foreach ($c in $cols) { $batHtml += "<td>$($b.$c)</td>" }
        $batHtml += "</tr>"
    }
    $batHtml += "</table>"

    $recentHtml = "<h2>Recent Power Usage</h2><table><tr>"
    $rcols = $RecentUsage[0].PSObject.Properties | Select-Object -ExpandProperty Name
    foreach ($c in $rcols) { $recentHtml += "<th>$c</th>" }
    $recentHtml += "</tr>"
    foreach ($r in $RecentUsage) {
        $recentHtml += "<tr>"
        foreach ($c in $rcols) { $recentHtml += "<td>$($r.$c)</td>" }
        $recentHtml += "</tr>"
    }
    $recentHtml += "</table>"

    $footer = "</body></html>"
    $fullHtml = $header + $sysInfoHtml + $batHtml + $recentHtml + $footer
    Set-Content -Path $htmlPath -Value $fullHtml -Encoding UTF8

    Write-Host "`nBattery Health HTML report saved to: $htmlPath"
    $open = Read-Host "Open HTML report now? (Y/N)"
    if ($open.ToUpper() -eq "Y") { Invoke-Item $htmlPath }
}
