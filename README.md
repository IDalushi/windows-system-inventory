# Windows System Inventory

PowerShell script for collecting Windows hardware information,
checking drive space, and exporting CSV reports.

## Features

| Area | Information |
| --- | --- |
| CPU | Model, physical cores, logical processors |
| Memory | Total physical memory in GiB |
| Windows | Name, version, build, system drive |
| Drives | Letter, label, type, filesystem, capacity, used and free space |
| Alerts | Warning below a configurable free-space percentage |
| Export | Separate computer and drive CSV reports |

## Download and Run

Requires Windows, PowerShell with `Get-CimInstance`, permission
to execute scripts, and write access to the project folder.
Git and a code editor are not required.

1. Select **Code → Download ZIP** on this repository.
2. Extract the ZIP.
3. Open the folder containing `Get-SystemInventory.ps1`.
4. In File Explorer's address bar, type `powershell` and press Enter.
5. Run:

```powershell
.\Get-SystemInventory.ps1
```

The script checks the computer where it runs.

### If the downloaded script is blocked

Windows may mark downloaded scripts as coming from the internet.
If PowerShell reports that the script is not digitally signed,
check the active execution policy:

```powershell
Get-ExecutionPolicy
```

| Policy | Next step |
| --- | --- |
| `RemoteSigned` | Review the script, then unblock this file using the command below |
| `AllSigned` | A trusted digital signature is required; follow your organization's process |
| `Restricted` | Script execution is disabled; follow your organization's process |

Under `RemoteSigned`, after reviewing and trusting the script, run:

```powershell
Unblock-File -Path ".\Get-SystemInventory.ps1"
.\Get-SystemInventory.ps1
```

Unblocking removes the downloaded-file marker from this file.
It does not change the execution policy and normally only needs
to be done once per downloaded copy.

## Daily IT Use

| Situation | Practical use |
| --- | --- |
| Installation fails | Check Windows version and available drive space |
| Computer runs slowly | Check hardware specifications and low disk space |
| Workstation handover | Save a hardware and operating-system inventory |
| Upgrade planning | Compare RAM and storage with application requirements |
| USB file transfer | Check the connected drive's filesystem and free space |
| Support ticket | Attach CSV reports for another technician |

## Example Output

Fictional drive data with a 20% warning threshold:

| Drive | Capacity (GiB) | Free (GiB) | Free (%) | Status |
| --- | ---: | ---: | ---: | --- |
| C: | 500 | 75 | 15 | LOW SPACE |
| D: | 1000 | 700 | 70 | OK |
| E: (USB) | 64 | 48 | 75 | OK |

## Reports

| File | Contents |
| --- | --- |
| `reports/computer-inventory.csv` | CPU, memory, and Windows details |
| `reports/drive-inventory.csv` | One row per detected drive volume |

The reports folder is created beside the script.
Reports use UTF-8 and the regional CSV separator.
Each run overwrites the previous reports.

Open them in a CSV reader such as Excel. Review machine-specific
details before sharing. Generated reports are excluded from Git.

## Configuration

Change the warning threshold inside the script:

```powershell
$minimumFreePercent = 20
```

A warning appears when free space is below this percentage.

## Limitations

- Local inventory only; no remote scanning.
- Includes fixed and removable volumes with drive letters.
- Excludes network drives, optical drives, and volumes without letters.
- Reports volumes, not physical disks; USB disks may appear as `Fixed`.
- `OK` indicates sufficient free space, not disk health.
- No live performance monitoring; single-CPU reporting.
- System-query error handling is limited.

## Validation

Manually tested on Windows 11 Pro with three drive volumes.
Both CSV reports were exported and successfully imported into PowerShell.

## License

Licensed under the [MIT License](LICENSE).