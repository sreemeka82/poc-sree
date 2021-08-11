# to avoid accidently formatting your system drive
Get-Disk | Where-Object IsSystem -eq $False
Initialize-Disk 1,2 -PartitionStyle MBR -PassThru
New-Partition -DiskNumber 1 -UseMaximumSize -DriveLetter D
New-Partition -DiskNumber 2 -UseMaximumSize -DriveLetter T
Format-Volume -DriveLetter D,T -FileSystem NTFS -Confirm:$false
Set-Volume -DriveLetter D -NewFileSystemLabel "Data"
Set-Volume -DriveLetter T -NewFileSystemLabel "Temp"