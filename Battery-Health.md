# 🔋 Battery Health HTML Report

**Automated Health Audit for Windows Laptops**  
By [Chase Flores](https://chaseflores.vercel.app) | [github.com/djonpoint12](https://github.com/djonpoint12)

---

## Overview

This PowerShell script generates a comprehensive battery health report for **Windows 10/11 laptops**.  
It exports a clean, readable HTML file with all the vital battery metrics IT pros need—no vendor bloat, no guessing.

---

## Features

- **Laptop only**: Skips desktops, servers, and battery-less devices automatically.
- **Full health stats**: Health %, charge cycles, capacities, chemistry, and more.
- **Recent power usage**: See recent charge/discharge activity with timestamps.
- **Brandable, pro HTML report**: Drop it in a ticket, send to a user, or archive for asset management.
- **Zero dependencies**: Pure PowerShell. No 3rd-party modules or admin installs.

---

## Example Output

![Battery Health HTML Screenshot](./assets/sample-screenshot.png) <!-- Add a screenshot if you want -->

---

## Usage

1. **Download** [`Battery-Health.ps1`](./Battery-Health.ps1) to your laptop.
2. **Run as Administrator**:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Battery-Health.ps1
