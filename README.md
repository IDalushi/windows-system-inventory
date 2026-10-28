# Windows System Inventory

A PowerShell learning project developed during my Umschulung
as a Fachinformatiker für Systemintegration.

The script collects information about a Windows computer,
checks local drive volumes, and exports CSV reports.

## Features

- Displays processor name, physical cores, and logical processors.
- Reports physical memory in GiB.
- Displays Windows name, version, build, and system drive.
- Lists fixed and removable drive volumes.
- Calculates capacity, used space, free space, and free-space percentage.
- Warns when a drive has less than 20% free space.
- Exports separate computer and drive inventory reports.

## Requirements

- Windows with PowerShell and access to the queried CIM classes.
- Permission to write files in the project folder.
- Script execution permitted by the applicable PowerShell policy.

## Usage

Open PowerShell in the project folder and run:

```powershell
.\Get-SystemInventory.ps1
```

The script displays the results and creates these files:

- `reports/computer-inventory.csv`
- `reports/drive-inventory.csv`

Each run replaces the reports with current results.

CSV files use UTF-8 encoding and the regional list separator.
Storage and memory values use GiB: 1 GiB = 1,073,741,824 bytes.

## Warning threshold

The default threshold is 20% free space.
Change this variable in the script to adjust it:

```powershell
$minimumFreePercent = 20
```

The threshold is a project setting, not a universal requirement.

## Scope and limitations

- Inventories the computer on which the script runs.
- Lists logical drive volumes, not individual physical disks.
- Includes fixed and removable volumes with drive letters,
  including connected USB storage exposed in those categories.
- Excludes network drives, optical drives, and volumes without
  drive letters.
- Windows may classify a USB HDD or SSD as a fixed drive.
- Reports unavailable capacity values as unavailable.
- The current processor report is designed for a single-CPU system.

## Validation completed

- Ran the script on Windows 11 Pro.
- Retrieved CPU, memory, and operating-system information.
- Listed three drive volumes: C:, D:, and E:.
- Exported both CSV reports.
- Imported both reports back into PowerShell and checked their contents.

## What I am learning

- Querying Windows information with Get-CimInstance.
- Using variables, properties, and custom PowerShell objects.
- Processing multiple drives with foreach loops.
- Making decisions with if/else conditions.
- Converting bytes to GiB and calculating percentages.
- Exporting and importing CSV data.
- Using Git for version control.

## Generated reports

The reports folder is excluded from Git using .gitignore.
Reports generated on a user's computer remain local.

## Planned improvements

- Add fictional sample reports.
- Improve error handling for failed system queries.
- Add an HTML report.