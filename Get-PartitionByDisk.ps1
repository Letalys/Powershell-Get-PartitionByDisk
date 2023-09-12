<#
.SYNOPSIS
  Using WMI Class / CIM Instance
.DESCRIPTION
  Script allowing you to link the information of disks and their partitions
.OUTPUT
  Return Array
.NOTES
  Version:        1.0
  Author:         Letalys
  Creation Date:  12/09/2023
  Purpose/Change: Initial script development

.LINK
    Author : Letalys (https://github.com/Letalys)
#>

Function Get-PartitionByDisk{  
   # Get disk list
   $DiskArray = @()
   $Disks = Get-CimInstance -Class Win32_DiskDrive | Sort-Object DeviceID

    foreach ($d in $Disks) {
        $DiskIndex = $d.DeviceID -replace '\\\\.\\PHYSICALDRIVE', ''  # Get only disk Index number

        $DiskObject = New-Object PSObject
        $DiskObject | Add-Member -MemberType NoteProperty -Name "Disk" -Value $DiskIndex

        # Get partition list of current disk
        $PartArray = @()
        $Partitions = Get-CimInstance -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($d.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition"

        # Get partition info
        foreach ($p in $Partitions) {
            $LogicalDisk = Get-CimInstance -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($p.DeviceID)'} WHERE AssocClass=Win32_LogicalDiskToPartition"
            $VolumeName = (Get-CimInstance -Query "SELECT * FROM Win32_Volume WHERE DriveLetter='$($LogicalDisk.DeviceID)'").Label

            $PartObject = New-Object PSObject
            $PartObject | Add-Member -MemberType NoteProperty -Name "Index" -Value  $($p.Index)
            $PartObject | Add-Member -MemberType NoteProperty -Name "Letter" -Value "$($LogicalDisk.DeviceID)"
            $PartObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $VolumeName
            $PartObject | Add-Member -MemberType NoteProperty -Name "Type" -Value "$($p.Type)"

            $PartArray += $PartObject
        }

        $DiskObject | Add-Member -MemberType NoteProperty -Name "Partition" -Value $PartArray
        $DiskArray += $DiskObject
    }

    Return $DiskArray
}
