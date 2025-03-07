# Erforderliche .NET-Assemblies für Windows Forms und Drawing laden
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Hauptfenster erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = 'RDP-Verbindung'
$form.Size = New-Object System.Drawing.Size(320,430)
$form.StartPosition = 'CenterScreen'

# Beschriftung für das Server-Eingabefeld erstellen
$serverLabel = New-Object System.Windows.Forms.Label
$serverLabel.Location = New-Object System.Drawing.Point(10,20)
$serverLabel.Size = New-Object System.Drawing.Size(280,20)
$serverLabel.Text = 'Server:'
$form.Controls.Add($serverLabel)

# Eingabefeld für den Servernamen erstellen
$serverTextBox = New-Object System.Windows.Forms.TextBox
$serverTextBox.Location = New-Object System.Drawing.Point(10,40)
$serverTextBox.Size = New-Object System.Drawing.Size(280,20)
$form.Controls.Add($serverTextBox)

# Checkbox für das Anhängen des FQDN erstellen
$fqdnCheckBox = New-Object System.Windows.Forms.CheckBox
$fqdnCheckBox.Location = New-Object System.Drawing.Point(10,70)
$fqdnCheckBox.Size = New-Object System.Drawing.Size(280,20)
$fqdnCheckBox.Text = 'FQDN anhängen (.fqdn.fqdn.local)'
$fqdnCheckBox.Checked = $true  # Standardmäßig aktiviert
$form.Controls.Add($fqdnCheckBox)

# Array mit RDP-Parametern definieren
$checkBoxes = @{}
$options = @('/multimon', '/span', '/admin', '/public', '/remoteguard', '/restrictedadmin')
$y = 100  # Startposition für die Parameter-Checkboxen

# Checkboxen für RDP-Parameter erstellen
foreach ($option in $options) {
    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Location = New-Object System.Drawing.Point(10, $y)
    $checkBox.Size = New-Object System.Drawing.Size(280,20)
    $checkBox.Text = $option
    $checkBox.Checked = ($option -eq '/public')  # '/public' standardmäßig aktiviert
    $form.Controls.Add($checkBox)
    $checkBoxes[$option] = $checkBox
    $y += 30  # Vertikaler Abstand zwischen den Checkboxen
}

# Beschriftung für das benutzerdefinierte Parameter-Eingabefeld erstellen
$customParamLabel = New-Object System.Windows.Forms.Label
$customParamLabel.Location = New-Object System.Drawing.Point(10,$y)
$customParamLabel.Size = New-Object System.Drawing.Size(280,20)
$customParamLabel.Text = 'Benutzerdefinierter Parameter:'
$form.Controls.Add($customParamLabel)

# Eingabefeld für benutzerdefinierte Parameter erstellen
$customParamTextBox = New-Object System.Windows.Forms.TextBox
$customParamTextBox.Location = New-Object System.Drawing.Point(10, ($y + 20))
$customParamTextBox.Size = New-Object System.Drawing.Size(280,20)
$form.Controls.Add($customParamTextBox)

# "Verbinden"-Button erstellen
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10, ($y + 60))
$button.Size = New-Object System.Drawing.Size(280,30)
$button.Text = 'Verbinden'

# Ereignishandler für den "Verbinden"-Button definieren
$button.Add_Click({
    $rdpArgs = @()
    $selectedOptions = @()

    # Servername verarbeiten und ggf. FQDN anhängen
    $serverName = $serverTextBox.Text
    if ($fqdnCheckBox.Checked) {
        $serverName += ".fqdn.fqdn.local"
    }
    $rdpArgs += "/v:$serverName"
    $selectedOptions += "/v:$serverName"

    # Ausgewählte RDP-Parameter hinzufügen
    foreach ($option in $options) {
        if ($checkBoxes[$option].Checked) {
            $rdpArgs += $option
            $selectedOptions += $option
        }
    }

    # Benutzerdefinierte Parameter hinzufügen (falls vorhanden)
    if ($customParamTextBox.Text) {
        $rdpArgs += $customParamTextBox.Text.Trim()
        $selectedOptions += $customParamTextBox.Text.Trim()
    }

    # Nachricht für das Popup-Fenster vorbereiten
    $messageBody = if ($selectedOptions) {
        "Ausgewählte Optionen:`n" + ($selectedOptions -join "`n")
    } else {
        "Keine Optionen ausgewählt."
    }

    # Popup-Fenster mit ausgewählten Optionen anzeigen
    [System.Windows.Forms.MessageBox]::Show($messageBody, "Ausgeführte Parameter", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

    # RDP-Verbindung starten (falls Argumente vorhanden sind)
    if ($rdpArgs) {
        Start-Process mstsc.exe -ArgumentList $rdpArgs
    }
})
$form.Controls.Add($button)

# Formular anzeigen
$form.ShowDialog()
