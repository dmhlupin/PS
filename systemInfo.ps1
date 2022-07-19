Set-ExecutionPolicy RemoteSigned -Scope Process

$fname = "C:/systemInfo.txt"
$CPU = Get-WmiObject -Class win32_processor
$MB = Get-WmiObject -Class win32_baseboard
$MEM = Get-WmiObject -Class win32_PhysicalMemory
$DD = Get-PhysicalDisk
$pcn = Get-WmiObject -Class Win32_ComputerSystem


#имя компьютера

"pcname:    "+$pcn.Name | Out-File -FilePath $fname -Append -Encoding default

# ip-адрес по имени

Get-WmiObject Win32_NetworkAdapter -Filter 'NetConnectionStatus=2' | 
ForEach-Object {
    $pcip = 1 | Select-Object IP
    $config = $_.GetRelated('Win32_NetworkAdapterConfiguration')
    $pcip.IP = $config | Select-Object -expand IPAddress
    $pcip
}
foreach($aip in $pcip) {
    "IP:    "+$aip.IP | Out-File -FilePath $fname -Append -Encoding default
}

# имя активного пользователя

"username:    "+$pcn.PrimaryOwnerName | Out-File -FilePath $fname -Append -Encoding default

# модель ПК

"PC model:    "+$pcn.Model | Out-File -FilePath $fname -Append -Encoding default

# процессор

$num = 0

foreach($processor in $CPU) {
    $num = $num+1
    "CPU"+$num+":    "+$processor.Name | Out-File -FilePath $fname -Append -Encoding default
}

# память

$num = 0
foreach($memory in $MEM) {
    $num = $num+1
    "MEMORY "+$num+":    "+$memory.PartNumber+"   "+$memory.Capacity+"    "+$memory.Speed | Out-File -FilePath $fname -Append -Encoding default
}

# материнская плата

"MB:    "+$MB.Product | Out-File -FilePath $fname -Append -Encoding default

# диски

$num = 0
foreach($disk in $DD){
    $num = $num+1
    "DISK "+$num+":  "+$disk.FriendlyName+"  "+$disk.Size+"  "+$disk.MediaType | Out-File -FilePath $fname -Append -Encoding default
}