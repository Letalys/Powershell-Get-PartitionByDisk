
# Powershell : Get-PartitionByDisk

I created this script to make it easier for me to recover information between physical disks and partitions. There are several WMI classes allowing you to have information on one or the other. I made the function which allows you to link the two. 

This is particularly useful for me in SCCM/MECM during my OSD to know on which disk to install the system.






## How to use

### Examples

__*Example 1 :*__

```
Get-PartitionByDisk
```

```
Disk Partition
---- ---------
0    {@{Index=0; Letter=; Name=; Type=GPT: System}, @{Index=1; Letter=C:; Name=Windows; Type=GPT: Basic Data}, @{Index=2; Letter=; Name=; Type=GPT: Unknown}}
1    {@{Index=0; Letter=D:; Name=VMs; Type=GPT: Basic Data}}
```

__*Example 2 :*__

```
Get-PartitionByDisk | Select-Object Disk -ExpandProperty Partition | Where-Object {$_.Name -eq "Windows"} | Format-Table
```

```
Index Letter Name    Type            Disk
----- ------ ----    ----            ----
    1 C:     Windows GPT: Basic Data 0
```
__*Example 3 :*__

```
Get-PartitionByDisk | Select-Object Disk -ExpandProperty Partition | Format-Table
```

```
Index Letter Name    Type            Disk
----- ------ ----    ----            ----
    0                GPT: System     0
    1 C:     Windows GPT: Basic Data 0
    2                GPT: Unknown    0
    0 D:     VMs     GPT: Basic Data 1
```

__*Example 4 :*__

```
Get-PartitionByDisk | Where-Object {$_.Disk -eq 0} | Select-Object Disk -ExpandProperty Partition  | Format-Table
```

```
Index Letter Name    Type            Disk
----- ------ ----    ----            ----
    0                GPT: System     0
    1 C:     Windows GPT: Basic Data 0
    2                GPT: Unknown    0
```
## Links
https://github.com/Letalys/Powershell-Get-PartitionByDisk


## Autor
- [@Letalys (GitHUb)](https://www.github.com/Letalys)
