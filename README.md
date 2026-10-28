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

## Run

Requires Windows, PowerShell with `Get-CimInstance`, and permission
to execute the script and write reports.

```powershell
.\Get-SystemInventory.ps1
```

## Daily IT Use

| Situation | Practical use |
| --- | --- |
| Installation fails | Check Windows version and available drive space |
| Computer runs slowly | Check hardware specifications and low disk space |
| Workstation handover | Save a hardware and operating-system inventory |
| Upgrade planning | Compare RAM and storage with application requirements |
| USB file transfer | Check the connected drive’s filesystem and free space |
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

Reports use UTF-8 and the regional CSV separator.
Each run overwrites the previous reports.
The `reports` folder is excluded from Git.

## Configuration

Change the warning threshold inside the script:

```powershell
$minimumFreePercent = 20
```

## Limitations

- Local inventory only; no remote scanning.
- Includes fixed and removable volumes with drive letters.
- Excludes network drives, optical drives, and volumes without letters.
- Reports volumes, not physical disks; USB disks may appear as `Fixed`.
- `OK` indicates sufficient free space, not disk health.
- No live performance monitoring; single-CPU reporting.
- System-query error handling is limited.
