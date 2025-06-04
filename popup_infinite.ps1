Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Media

# Ścieżka tymczasowa na dźwięk
$soundPath = "$env:TEMP\scary_sound.wav"

# Pobierz dźwięk z GitHub (podmień link na swój, jeśli chcesz)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/PNTR-CWL/flipper-fakemalware/main/scary_sound.wav" -OutFile $soundPath

function Show-DeadWindow {
    $form = New-Object Windows.Forms.Form
    $form.Text = "💀 WARNING"
    $form.TopMost = $true
    $form.FormBorderStyle = 'FixedDialog'
    $form.ControlBox = $true
    $form.StartPosition = 'Manual'
    $form.Size = New-Object Drawing.Size(200,100)

    $label = New-Object Windows.Forms.Label
    $label.Text = "YOU ARE DEAD"
    $label.Dock = 'Fill'
    $label.TextAlign = 'MiddleCenter'
    $label.Font = New-Object Drawing.Font("Arial",14,[Drawing.FontStyle]::Bold)
    $form.Controls.Add($label)

    # Losowa pozycja na ekranie
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $randX = Get-Random -Minimum 0 -Maximum ($screen.Width - 200)
    $randY = Get-Random -Minimum 0 -Maximum ($screen.Height - 100)
    $form.Location = New-Object Drawing.Point($randX, $randY)

    # Przygotuj SoundPlayer i odtwarzaj pętlę
    $soundPlayer = New-Object System.Media.SoundPlayer
    $soundPlayer.SoundLocation = $soundPath
    $soundPlayer.Load()
    $soundPlayer.PlayLooping()

    # Po kliknięciu lub zamknięciu tworzy nowe okno (nowy proces w tle)
    $form.Add_Click({ Start-Job { Show-DeadWindow } })
    $form.Add_FormClosed({
        $soundPlayer.Stop()
        Start-Job { Show-DeadWindow }
    })

    # Timer do ruchu okienka
    $timer = New-Object Windows.Forms.Timer
    $timer.Interval = 150
    $timer.Add_Tick({
        $dx = Get-Random -Minimum -40 -Maximum 40
        $dy = Get-Random -Minimum -40 -Maximum 40
        $newX = [Math]::Max(0, [Math]::Min($screen.Width - 200, $form.Location.X + $dx))
        $newY = [Math]::Max(0, [Math]::Min($screen.Height - 100, $form.Location.Y + $dy))
        $form.Location = New-Object Drawing.Point($newX, $newY)
    })
    $timer.Start()

    [void]$form.ShowDialog()
}

Show-DeadWindow
