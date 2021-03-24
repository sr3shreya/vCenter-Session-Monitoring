cls
Function Get-ViSession {
$x=Connect-VIServer vc1.demo.netapp.com -User YOURUSERNAME -Password YOURPASSWORD
$SessionMgr = Get-View $x.ExtensionData.Client.ServiceContent.SessionManager
$AllSessions = @()
$SessionMgr.SessionList | Foreach {
$Session = New-Object -TypeName PSObject -Property @{
Key = $_.Key
UserName = $_.UserName
FullName = $_.FullName
LoginTime = ($_.LoginTime).ToLocalTime()
LastActiveTime = ($_.LastActiveTime).ToLocalTime()
}
If ($_.Key -eq $SessionMgr.CurrentSession.Key) {
$Session | Add-Member -MemberType NoteProperty -Name Status -Value “Current Session”
} Else {
$Session | Add-Member -MemberType NoteProperty -Name Status -Value “Idle”
}
$Session | Add-Member -MemberType NoteProperty -Name IdleMinutes -Value ([Math]::Round(((Get-Date) – ($_.LastActiveTime).ToLocalTime()).TotalMinutes))
$AllSessions += $Session
}
$AllSessions
}
$allses=Get-ViSession 
$activecount=0;
$idlecount=0;
if ($allses.count -gt 1)
{

    foreach ($sess in $allses)

    {

        if ($sess.IdleMinutes -ge 5)
        {
        $idlecount+=1;
        }
        else {
        $sess.Status = "Active Session"
        $activecount+=1;
        }

    }

    $active= $activecount+1
    $idlecount=$idlecount-1
    write-host " Active sessions count are " $active
    write-host " idle session count is " $idlecount

}

elseif( $allses.count -eq 1)
{
write-host " Active sessions count is 1"
}
else {Write-host " No active session found"}


  


