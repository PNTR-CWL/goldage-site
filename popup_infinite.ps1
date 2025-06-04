Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

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

    # Losowa pozycja
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $rand = Get-Random -Minimum 0 -Maximum ($screen.Width - 200)
    $rand2 = Get-Random -Minimum 0 -Maximum ($screen.Height - 100)
    $form.Location = New-Object Drawing.Point($rand, $rand2)

    # Obsługa kliknięcia i zamknięcia — tworzy nowe
    $form.Add_Click({ Start-Job { Show-DeadWindow } })
    $form.Add_FormClosed({ Start-Job { Show-DeadWindow } })

    # Ruch okna
    $timer = New-Object Windows.Forms.Timer
    $timer.Interval = 150
    $timer.Add_Tick({
        $dx = Get-Random -Minimum -40 -Maximum 40
        $dy = Get-Random -Minimum -40 -Maximum 40
        $x = [Math]::Max(0, [Math]::Min($screen.Width - 200, $form.Location.X + $dx))
        $y = [Math]::Max(0, [Math]::Min($screen.Height - 100, $form.Location.Y + $dy))
        $form.Location = New-Object Drawing.Point($x, $y)
    })
    $timer.Start()

    [void]$form.ShowDialog()
}

Show-DeadWindow
