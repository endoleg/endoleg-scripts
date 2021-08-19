########################################################################################
# functions
########################################################################################
function Export-RegTree([string]$regkey,[string]$exportpath){
    $data1 = @()
    $createobject = {
        param($k,$n)
        [pscustomobject] @{
            Name = @{$true='(Default)';$false=$n}[$n -eq '']
            Value = $k.GetValue($n)
            Path = $k.PSPath
            Type = $k.GetValueKind($n)
        }
    }
    get-item $regkey -PipelineVariable key| %{
        $key.GetValueNames() | %{$data1 += . $createobject $key $_}
    }
    gci $regkey -Recurse -Force -PipelineVariable key | %{
        $key.GetValueNames() | %{$data1 += . $createobject $key $_}
    }
   $data1 
}

function Import-RegTree([string][ValidateScript({Test-Path $_})]$xmlfile){
    Import-Clixml $xmlfile | %{
        if (!(Test-Path $_.Path)){md $_.Path -Force | out-null}
        New-ItemProperty -Path $_.Path -Name $_.Name -Value $_.Value -PropertyType $_.Type -Force
    }
}


########################################################################################
# Export and join V1
########################################################################################
$a = Export-RegTree 'HKCU:\Software\Microsoft\Office\Outlook'
$b = Export-RegTree 'HKCU:\Software\Microsoft\Office\16.0\Wef\Providers'
$c = Export-RegTree 'HKCU:\Software\Microsoft\Office\16.0\Outlook'
$d = $a + $b + $c
$d | Export-Clixml "c:\users\$env:username\Regbackup-Outlook-16-Combi.xml" -Force

########################################################################################
# Export and join V2
########################################################################################
$combi5 = @{
OfficeOutlook = (Export-RegTree1 'HKCU:\Software\Microsoft\Office\Outlook') ;
WefProviders = (Export-RegTree3 'HKCU:\Software\Microsoft\Office\16.0\Wef\Providers') ;
Outlook160 = (Export-RegTree3 'HKCU:\Software\Microsoft\Office\16.0\Outlook')
}
$combi5 | Export-Clixml "c:\users\$env:username\Regbackup-Outlook-16-Combi-array.xml" -Force

    #clear
    #$combi5.Outlook160
    #$combi5.WefProviders
    #$combi5.OfficeOutlook


########################################################################################
## Import would look like this
########################################################################################
# Import-RegTree "c:\users\$env:username\Regbackup-Outlook-16-Combi.xml"
# Import-RegTree "c:\users\$env:username\Regbackup-Outlook-16-Combi-array.xml"

