# Load the necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to populate TreeView with directory structure
function Populate-TreeView {
    param (
        [System.Windows.Forms.TreeNode]$node,
        [string]$path
    )
    
    # Get directories
    $directories = Get-ChildItem -Path $path -Directory
    foreach ($dir in $directories) {
        $childNode = $node.Nodes.Add($dir.Name)
        Populate-TreeView -node $childNode -path $dir.FullName
    }

    # Get files
    $files = Get-ChildItem -Path $path -File
    foreach ($file in $files) {
        $node.Nodes.Add($file.Name)
    }
}

# Create a new form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Directory Tree Viewer"
$form.Size = New-Object System.Drawing.Size(400, 500)

# Create a TreeView control
$treeView = New-Object System.Windows.Forms.TreeView
$treeView.Location = New-Object System.Drawing.Point(10, 10)
$treeView.Size = New-Object System.Drawing.Size(360, 400)
$treeView.PathSeparator = [System.IO.Path]::DirectorySeparatorChar

# Create a button to load a directory
$button = New-Object System.Windows.Forms.Button
$button.Text = "Load Directory"
$button.Location = New-Object System.Drawing.Point(10, 420)

# FolderBrowserDialog to choose a directory
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

# Button click event to load directory
$button.Add_Click({
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $treeView.Nodes.Clear()
        $rootNode = $treeView.Nodes.Add($folderBrowser.SelectedPath)
        Populate-TreeView -node $rootNode -path $folderBrowser.SelectedPath
        $rootNode.Expand()
    }
})

# Add controls to the form
$form.Controls.Add($treeView)
$form.Controls.Add($button)

# Display the form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
