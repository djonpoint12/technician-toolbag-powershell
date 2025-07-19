param (
    [Parameter(Mandatory=$true)]
    [string]$printerNameTarget
)

# ===== CONFIGURATION =====
$printServer = "<PRINT_SERVER_NAME>"  # Replace this with your print server hostname

# ===== FETCH PRINTER LIST FROM SERVER =====
try {
    $printers = Get-Printer -ComputerName $printServer -Full
} catch {
    Write-Output "ERROR: Could not connect to print server '$printServer'."
    exit 1
}

# ===== FIND TARGET PRINTER =====
$printer = $printers | Where-Object { $_.Name -eq $printerNameTarget }

if (-not $printer) {
    Write-Output "WARNING: Printer '$printerNameTarget' not found on server '$printServer'."
    exit 1
}

# ===== BUILD CONNECTION INFO =====
$connectionName = "\\$printServer\$($printer.Name)"
$portName = $printer.PortName
$driverName = $printer.DriverName

# ===== CHECK IF PRINTER IS ALREADY INSTALLED =====
$existingPrinter = Get-Printer | Where-Object { $_.Name -eq $printer.Name }

if ($existingPrinter) {
    Write-Output "INFO: Printer '$($printer.Name)' already exists on this device. Skipping installation."
    exit 0
}

# ===== INSTALL PRINTER IF SHARED =====
if ($printer.Shared) {
    Write-Output "INFO: Adding printer '$connectionName'."

    try {
        # Add printer port (using port name)
        if (-not (Get-PrinterPort -Name $portName -ErrorAction SilentlyContinue)) {
            Add-PrinterPort -Name $portName -PrinterHostAddress $portName
            Write-Output "Port '$portName' created."
        } else {
            Write-Output "Port '$portName' already exists."
        }

        # Add printer driver
        Add-PrinterDriver -Name $driverName
        Write-Output "Driver '$driverName' added."

        # Add printer
        Add-Printer -Name $printer.Name -DriverName $driverName -PortName $portName
        Write-Output "Printer '$($printer.Name)' installed successfully."

    } catch {
        Write-Output "ERROR: Failed to add printer '$($printer.Name)'. Error: $_"
        exit 1
    }
} else {
    Write-Output "WARNING: Printer '$($printer.Name)' is not shared on server '$printServer'."
    exit 1
}
