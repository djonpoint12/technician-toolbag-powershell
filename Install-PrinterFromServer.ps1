# Install-PrinterFromServer.ps1

This PowerShell script is designed to be used within **NinjaOne** to install a shared printer from a remote print server onto a client device. It takes the name of the printer as a parameter (ideal for dropdown selection) and performs checks to avoid redundant installations.

---

## 🔧 Parameters

### `printerNameTarget` (String) - **Required**
The exact name of the shared printer to install. This is typically passed in from NinjaOne as a dropdown list of known printers.

---

## 🖨️ What It Does

1. Connects to a remote print server.
2. Retrieves the list of shared printers.
3. Matches the selected printer name.
4. Verifies the printer is shared.
5. Checks if the printer already exists on the device.
6. Adds:
   - A printer port (if it doesn't already exist)
   - The printer driver
   - The printer itself

---

## 🖥️ Usage in NinjaOne

1. Create a **script parameter** called `printerNameTarget` and configure it as a dropdown.
2. Paste the script into NinjaOne’s script editor.
3. Replace `<PRINT_SERVER_NAME>` in the script with the actual hostname of your print server.
4. When deploying, select the desired printer from the dropdown.

---

## ✅ Example Usage

```powershell
Install-PrinterFromServer.ps1 -printerNameTarget "HP-LaserJet-AdminOffice"
