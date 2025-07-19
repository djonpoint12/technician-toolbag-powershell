# technician-toolbag-powershell
# 🔧 NinjaOne + PowerShell Tools by Chase Flores

A curated collection of PowerShell scripts I've written to solve real-world problems in IT environments — especially for use with **NinjaOne**, **Windows Autopilot**, **asset management**, and **end-user automation**.

> 📍 Author: Chase Flores  
> 🌐 [chaseflores.vercel.app](https://chaseflores.vercel.app) | [github.com/djonpoint12](https://github.com/djonpoint12)

---

## 📜 Script Index

| Script Name | Description | Use Case | Status |
|-------------|-------------|----------|--------|
| `Set-HardwareHashToNinja.ps1` | Collects Windows Autopilot hardware hash and stores it in a NinjaOne custom field | Pre-stage Autopilot devices from remote endpoints | ✅ Stable |
| `Install-PrinterFromServer.ps1` | Installs a shared printer from a print server via dropdown in NinjaOne | Automates printer deployments to end-user devices | ✅ Stable |
| `Get-BatteryHealth.ps1` | Retrieves battery wear level and stores it in NinjaOne or CSV | Monitor battery degradation across fleet | ✅ Stable |
| `Remove-Bloatware.ps1` | Removes unnecessary default Windows apps with a whitelist model | Speeds up and cleans up new device deployments | 🚧 In Progress |
| `Get-HPWarranty.ps1` | Uses HP API to fetch warranty data based on serial number | Audit warranties across HP devices | ✅ Stable |
| `Deploy-DiskCleanup.ps1` | Cleans temp files, clears cache, and runs Disk Cleanup silently | Automated cleanup to free up disk space | ✅ Stable |
| `Clear-PrintQueue.ps1` | Clears all stuck print jobs from the print queue | Helps techs resolve common printing issues fast | ✅ Stable |
| `Report-DiskUsage.ps1` | Reports largest folders/files to identify disk hogs | Helps IT diagnose space issues remotely | 🧪 Testing |
| `Reset-NetworkAdapter.ps1` | Disables/enables the adapter, clears DNS, and flushes cache | Helps users with network problems without manual steps | ✅ Stable |

---

## 🔄 Integration Notes

- Scripts are written to work **standalone** or integrate with **NinjaOne's custom fields and parameters**.
- Many scripts use:
  - `Ninja-Property-Set` to store values
  - Dropdown inputs via NinjaOne’s parameter UI
  - Logging via `Write-Output` for Ninja's activity stream

---

## 💻 Use These Scripts For

- 🔁 Bulk automation tasks across remote endpoints  
- ⚙️ Hardware + asset auditing  
- 📠 Printer provisioning  
- 📋 Autopilot staging  
- 💥 End-user issue resolution  
- 🧽 Device cleanup and optimization  

---

## 🧠 Tips

- Clone the repo and **customize scripts to match your environment**
- Pair with NinjaOne’s **scheduled jobs** or **automated policies**
- Use `Custom Fields` to unlock **filterable reporting** across scripts

---

## 📥 How to Contribute

This is a personal collection, but feel free to fork or suggest improvements via Issues or PRs.

---

## 🏷 License

MIT License (or your preferred license)

---

## 🧍 About the Author

I'm an IT Systems Analyst who builds automation, solves problems, and writes code that actually gets used in the field — from managing thousands of devices to DJ'ing events on the weekend.

If you use any of these tools — hit me up, I’d love to hear how they help.

> **Chase Flores**  
> 📧 chase.codes@pm.me  
> 🧠 [chaseflores.vercel.app](https://chaseflores.vercel.app)  
> 🛠 [github.com/djonpoint12](https://github.com/djonpoint12)

