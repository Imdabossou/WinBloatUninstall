# Remove WSL
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
echo skip | wsl --uninstall

# Enable Digital Market Act Mode
Takeown /F "C:\Windows\System32\IntegratedServicesRegionPolicySet.json"
icacls "C:\Windows\System32\IntegratedServicesRegionPolicySet.json" /grant SYSTEM:F
Set-Acl "C:\Windows\System32\IntegratedServicesRegionPolicySet.json" (Get-Acl "C:\Windows\System32\IntegratedServicesRegionPolicySet.json" | ForEach-Object { $_.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.WindowsIdentity]::GetCurrent().Name,"FullControl","None","None","Allow"))); $_ })
Copy-Item "IntegratedServicesRegionPolicySet.json" "C:\Windows\System32\" -Force -ErrorAction SilentlyContinue

#Remove Unused UWP Apps
$AppList = "Microsoft.WindowsFeedbackHub",
"Microsoft.GetHelp",
"microsoft.windowscommunicationsapps",
"Microsoft.MicrosoftOfficeHub",
"Clipchamp.Clipchamp",
"Microsoft.People",
"Microsoft.MicrosoftSolitaireCollection",
"MicrosoftTeams",
"Microsoft.SkypeApp",
"Microsoft.Getstarted",
"Microsoft.BingWeather",
"Microsoft.BingNews",
"Microsoft.BingFinance",
"Microsoft.BingSports",
"Microsoft.GamingApp",
"Microsoft.XboxApp",
"Microsoft.XboxSpeechToTextOverlay",
"Microsoft.XboxIdentityProvider",
"Microsoft.Xbox.TCUI",
"Microsoft.XboxGameOverlay",
"Microsoft.XboxGamingOverlay",
"Microsoft.OutlookForWindows",
"Microsoft.549981C3F5F10",
"DellInc.DellDigitalDelivery",
"MicrosoftCorporationII.MicrosoftFamily",
"AD2F1837.HPPrinterControl",
"Microsoft.Office.OneNote",
"SpotifyAB.SpotifyMusic",
"7EE7776C.LinkedInforWindows",
"DellInc.DellDigitalDelivery",
"Microsoft.Advertising.Xaml",
"Microsoft.MixedReality.Portal",
"Microsoft.Wallet",
"5319275A.WhatsAppDesktop"

ForEach ($App in $AppList)
{

$PackageFullName = (Get-AppxPackage $App -Allusers).PackageFullName
$ProPackageFullName = (Get-AppxProvisionedPackage -online | where {$_.Displayname -eq $App}).PackageName

if ($PackageFullName){
Write-Output "Removing Package: $App"
try {
remove-AppxPackage -package $PackageFullName -ErrorAction Stop -Allusers | Out-Null
}
catch {
Write-Output "ERROR: $_"
}

}
else {
Write-Output "WARNING: Unable to find package: $App"
}

if ($ProPackageFullName){
Write-Output "Removing Provisioned Package: $ProPackageFullName"
try {
Remove-AppxProvisionedPackage -online -packagename $ProPackageFullName -AllUsers -ErrorAction Stop | Out-Null
}
catch {
Write-Output "ERROR: $_"
}
}
else{
Write-Output "WARNING: Unable to find provisioned package: $App"
}

}