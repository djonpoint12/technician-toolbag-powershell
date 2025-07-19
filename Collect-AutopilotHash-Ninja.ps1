<#
.SYNOPSIS
    Retrieves the Windows Autopilot hardware hash from a device and stores it in a NinjaOne custom field.

.DESCRIPTION
    This script is designed for use with NinjaOne. It collects the ZTD hardware hash using the WindowsAutopilotIntune module 
    and saves it to a NinjaOne custom field named "hardwareHash" (or a custom name if specified).

    This allows administrators to easily export hardware hashes from NinjaOne for bulk upload to Intune Autopilot.

.INSTRUCTIONS
    1. In NinjaOne, create a custom field for devices called `hardwareHash` (or another name of your choice).
    2. Deploy this script via NinjaOne to target devices.
    3. After deployment, use a custom field report or export to CSV for Intune import.

.AUTHOR
    By Chase Flores | github.com/djonpoint12 | chaseflores.vercel.app
#>

[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $CustomField = "hardwareHash"
)

begin {
    $ModuleName = "WindowsAutopilotIntune"
    $NinjaCommand = "Ninja-Property-Set"

    # Install module if missing
    if (-not (Get-Module -ListAvailable | Where-Object { $_.Name -eq $ModuleName })) {
        try {
            Install-Module -Name $ModuleName -Force -Scope CurrentUser -ErrorAction Stop
        } catch {
            Write-Output "ERROR: Failed to install module '$ModuleName'. $_"
            exit 1
        }
    }

    # Import module
    try {
        Import-Module $ModuleName -ErrorAction Stop
    } catch {
        Write-Output "ERROR: Could not import module '$ModuleName'. $_"
        exit 1
    }
}

process {
    # Retrieve hardware hash
    try {
        $hardwareHash = Get-WindowsAutopilotInfo | Select-Object -ExpandProperty ZtdHardwareHash
    } catch {
        Write-Output "ERROR: Failed to retrieve hardware hash. $_"
        exit 1
    }

    if (-not $hardwareHash) {
        Write-Output "ERROR: Hardware hash is null or empty. Aborting."
        exit 1
    }

    # Check if Ninja-Property-Set is available
    if (Get-Command $NinjaCommand -ErrorAction SilentlyContinue) {
        try {
            Ninja-Property-Set -Name $CustomField -Value $hardwareHash
            Write-Output "SUCCESS: Hardware hash stored in custom field '$CustomField'."
        } catch {
            Write-Output "ERROR: Failed to set NinjaOne custom field. $_"
            exit 1
        }
    } else {
        Write-Output "ERROR: Ninja-Property-Set command not found. Ensure script is run inside NinjaOne with proper integration."
        exit 1
    }
}

end {}
