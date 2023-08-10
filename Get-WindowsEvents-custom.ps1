<#
This is a PowerShell function named Get-WindowsEvents-custom that retrieves Windows events from a remote computer using an XML file containing custom event views. The function takes two parameters: $ComputerName specifies the name of the remote computer to retrieve events from, and $xmlFilePathFolder specifies the folder path where the XML file is located. If $xmlFilePathFolder is not specified, the default value is "c:\Windows\Temp\custom-event-Views-xml-files".
The function first uses Get-ChildItem to retrieve a list of XML files in the specified folder path. It then displays the list of files in an Out-GridView dialog box and waits for the user to select a file. If a file is selected, the function uses Select-Xml to retrieve the QueryList node from the XML file and converts it to a string. The function then uses the Get-WinEvent cmdlet to retrieve the Windows events from the remote computer using the FilterXML parameter and the QueryList XML string. Finally, the function adds a calculated property named "Details" to the output object that contains the full XML details of each event, and displays the results in an Out-GridView dialog box.
Here's an example of how to use the Get-WindowsEvents-custom function to retrieve Windows events from a remote computer named "Server1":
powershell
Get-WindowsEvents-custom -ComputerName "Server1"

This will display a list of XML files in the default folder path "c:\Windows\Temp\custom-event-Views-xml-files". Select an XML file from the list and click "OK" to retrieve the Windows events from the remote computer. The results will be displayed in an Out-GridView dialog box.

#>


function Get-WindowsEvents-custom {
    param(
        [string]$ComputerName,
        [string]$xmlFilePathFolder = "c:\Windows\Temp\custom-event-Views-xml-files\"
    )
# Use Out-GridView to select the XML file path
$xmlFilePath = Get-ChildItem -Path $xmlFilePathFolder | Out-GridView -Title "Select XML File" -PassThru
# Check if a file was selected
if ($xmlFilePath) {
    # Define the XPath expression to select the QueryList node
    $xPathExpression = "//QueryList"
    # Use Select-Xml to retrieve the QueryList node from the XML file
    $queryList = Select-Xml -Path $xmlFilePath.FullName -XPath $xPathExpression | Select-Object -ExpandProperty Node
    # Convert the QueryList node to a string
    $queryListString = $queryList.OuterXml
    # Use the QueryList XML with the Get-WinEvent cmdlet
    Get-WinEvent -ComputerName $Zielcomputer -FilterXML $queryListString | Select-Object *, @{Name="Details";Expression={$_.ToXml()}} | Out-GridView -Title "Windows Events on $Zielcomputer"
}
}
Get-WindowsEvents-custom -ComputerName "Server1" #-xmlFilePathFolder " c:\Windows\Temp\custom-event-Views-xml-files-special-Version\"
