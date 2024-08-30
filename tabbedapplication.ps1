# Load the required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to get installed applications
function Get-InstalledApps {
    $apps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Select-Object DisplayName, DisplayVersion, Publisher |
        Where-Object { $_.DisplayName -and $_.Publisher -ne "" } |
        Sort-Object DisplayName
    return $apps
}

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "PowerShell Form with Tabs"
$form.Size = New-Object System.Drawing.Size(600, 400)

# Create the TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(580, 350)
$tabControl.Location = New-Object System.Drawing.Point(10, 10)

# Create TabPages
$tabPage1 = New-Object System.Windows.Forms.TabPage
$tabPage1.Text = "Tab 1"
$tabPage2 = New-Object System.Windows.Forms.TabPage
$tabPage2.Text = "Tab 2"
$tabPage3 = New-Object System.Windows.Forms.TabPage
$tabPage3.Text = "Installed Apps"

# Add controls to TabPages
$label1 = New-Object System.Windows.Forms.Label
$label1.Text = "This is Tab 1"
$label1.Location = New-Object System.Drawing.Point(20, 20)
$tabPage1.Controls.Add($label1)

$label2 = New-Object System.Windows.Forms.Label
$label2.Text = "This is Tab 2"
$label2.Location = New-Object System.Drawing.Point(20, 20)
$tabPage2.Controls.Add($label2)

# Add a DataGridView to Tab 3 to display installed apps
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Size = New-Object System.Drawing.Size(540, 280)
$dataGridView.Location = New-Object System.Drawing.Point(20, 20)
$dataGridView.ColumnCount = 3
$dataGridView.Columns[0].Name = "Application Name"
$dataGridView.Columns[1].Name = "Version"
$dataGridView.Columns[2].Name = "Publisher"
$tabPage3.Controls.Add($dataGridView)

# Populate the DataGridView with installed apps
$apps = Get-InstalledApps
foreach ($app in $apps) {
    $row = @($app.DisplayName, $app.DisplayVersion, $app.Publisher)
    $dataGridView.Rows.Add($row)
}

# Add TabPages to TabControl
$tabControl.TabPages.Add($tabPage1)
$tabControl.TabPages.Add($tabPage2)
$tabControl.TabPages.Add($tabPage3)

# Add the TabControl to the form
$form.Controls.Add($tabControl)

# Display the form
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
