# Collect general information from Windows
$cpu = Get-CimInstance -ClassName Win32_Processor
$computer = Get-CimInstance -ClassName Win32_ComputerSystem
$os = Get-CimInstance -ClassName Win32_OperatingSystem

# Convert memory from bytes to GiB
$ramGiB = [math]::Round($computer.TotalPhysicalMemory / 1GB, 2)

# Create the computer inventory
$inventory = [PSCustomObject]@{
    Processor         = $cpu.Name
    PhysicalCores     = $cpu.NumberOfCores
    LogicalProcessors = $cpu.NumberOfLogicalProcessors
    RAM_GiB           = $ramGiB
    WindowsName       = $os.Caption
    WindowsVersion    = $os.Version
    WindowsBuild      = $os.BuildNumber
    SystemDrive       = $os.SystemDrive
}

# Get fixed and removable drive volumes
# DriveType 2 = removable drive
# DriveType 3 = fixed/local drive
$disks = Get-CimInstance -ClassName Win32_LogicalDisk `
    -Filter "DriveType=2 OR DriveType=3"

# Set the warning threshold for every drive
$minimumFreePercent = 20

# Build one inventory record for each drive
$diskInventory = @(
    foreach ($disk in $disks) {

        # Identify how Windows classifies the drive
        $driveType = if ($disk.DriveType -eq 2) {
            "Removable"
        }
        else {
            "Fixed"
        }

        # Calculate values only when capacity information is available
        if ($null -ne $disk.Size -and $disk.Size -gt 0 -and
            $null -ne $disk.FreeSpace) {

            $sizeGiB = [math]::Round($disk.Size / 1GB, 2)
            $freeGiB = [math]::Round($disk.FreeSpace / 1GB, 2)
            $usedGiB = [math]::Round(
                ($disk.Size - $disk.FreeSpace) / 1GB, 2
            )

            # Use the unrounded percentage for the warning decision
            $freePercentRaw = ($disk.FreeSpace / $disk.Size) * 100
            $freePercent = [math]::Round($freePercentRaw, 2)

            $status = if ($freePercentRaw -lt $minimumFreePercent) {
                "LOW SPACE"
            }
            else {
                "OK"
            }
        }
        else {
            # Handle drives whose capacity cannot be read
            $sizeGiB = $null
            $freeGiB = $null
            $usedGiB = $null
            $freePercent = $null
            $status = "Unavailable"
        }

        # Create this drive's inventory record
        [PSCustomObject]@{
            Drive        = $disk.DeviceID
            Label        = $disk.VolumeName
            Type         = $driveType
            FileSystem   = $disk.FileSystem
            Size_GiB     = $sizeGiB
            Used_GiB     = $usedGiB
            Free_GiB     = $freeGiB
            Free_Percent = $freePercent
            Status       = $status
        }
    }
)

# Display general computer information
Write-Host "`n=== COMPUTER INFORMATION ==="
$inventory | Format-List

# Display all detected drive records
Write-Host "=== DRIVE INFORMATION ==="
Write-Host "Detected drive volumes: $($diskInventory.Count)"
$diskInventory | Format-Table -AutoSize

# Show a warning for each drive with low free space
foreach ($drive in $diskInventory) {
    if ($drive.Status -eq "LOW SPACE") {
        Write-Warning "Drive $($drive.Drive) has $($drive.Free_Percent)% free. Threshold: $minimumFreePercent%."
    }
}

# Create a reports folder beside this script
$reportFolder = Join-Path -Path $PSScriptRoot -ChildPath "reports"

New-Item -ItemType Directory -Path $reportFolder -Force `
    -ErrorAction Stop | Out-Null

# Build the output file paths
$computerReportPath = Join-Path $reportFolder "computer-inventory.csv"
$driveReportPath = Join-Path $reportFolder "drive-inventory.csv"

# Export the original data objects to CSV
$inventory | Export-Csv -Path $computerReportPath `
    -NoTypeInformation -Encoding UTF8 -UseCulture -ErrorAction Stop

$diskInventory | Export-Csv -Path $driveReportPath `
    -NoTypeInformation -Encoding UTF8 -UseCulture -ErrorAction Stop

# Confirm where the reports were saved
Write-Host "`nReports saved to: $reportFolder"