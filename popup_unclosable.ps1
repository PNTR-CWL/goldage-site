Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object Windows.Forms.Form
$form.Text = "💀 WARNING"
$form.TopMost = $true
$form.FormBorderStyle = 'FixedDialog'
$form.ControlBox = $false  # usuwa przyciski zamykania
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.StartPosition = 'Manual'
$form.Size = New-Object Drawing.Size(250,120)

$label = New-Object Windows.Forms.Label
$label.Text = "YOU ARE DEAD"
$label.Dock = 'Fill'
$label.TextAlign = 'MiddleCenter'
$label.Font = New-Object Drawing.Font("Arial",20,[Drawing.FontStyle]::Bold)
$form.Controls.Add($label)

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

# Ustaw na start losową pozycję
$randX = Get-Random -Minimum 0 -Maximum ($screen.Width - $form.Width)
$randY = Get-Random -Minimum 0 -Maximum ($screen.Height - $form.Height)
$form.Location = New-Object Drawing.Point($randX, $randY)

$timer = New-Object Windows.Forms.Timer
$timer.Interval = 50  # szybkie odświeżanie = szybki ruch

$timer.Add_Tick({
    $dx = Get-Random -Minimum -30 -Maximum 30
    $dy = Get-Random -Minimum -30 -Maximum 30
    $newX = [Math]::Max(0, [Math]::Min($screen.Width - $form.Width, $form.Location.X + $dx))
    $newY = [Math]::Max(0, [Math]::Min($screen.Height - $form.Height, $form.Location.Y + $dy))
    $form.Location = New-Object Drawing.Point($newX, $newY)
})

$timer.Start()

# Blokuj zamykanie okna — podpinamy zdarzenie FormClosing
$form.Add_FormClosing({
    $_.Cancel = $true
})

$form.ShowDialog()
