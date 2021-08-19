function Export-RegTree1([string]$regkey,[string]$exportpath){
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

#Export-RegTree1 'HKCU:\Software\Microsoft\Office\Outlook' | Export-Clixml "c:\users\$env:username\Regbackup-Outlook-16-Combi.xml" -Force
#Export-RegTree1 'HKCU:\Software\Microsoft\Office\1' | Export-Clixml "c:\users\$env:username\Regbackup-Outlook-16-Combi1.xml" -Force
#Export-RegTree1 'HKCU:\Software\Microsoft\Office\2' | Export-Clixml "c:\users\$env:username\Regbackup-Outlook-16-Combi2.xml" -Force




function Export-RegTree2([string]$regkey,[string]$exportpath){
    $data2 = @()
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
        $key.GetValueNames() | %{$data2 += . $createobject $key $_}
    }
    gci $regkey -Recurse -Force -PipelineVariable key | %{
        $key.GetValueNames() | %{$data2 += . $createobject $key $_}
    }
   $data2
}




function Export-RegTree3([string]$regkey,[string]$exportpath){
    $data3 = @()
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
        $key.GetValueNames() | %{$data3 += . $createobject $key $_}
    }
    gci $regkey -Recurse -Force -PipelineVariable key | %{
        $key.GetValueNames() | %{$data3 += . $createobject $key $_}
    }
   $data3
}



# Export
$a = Export-RegTree1 'HKCU:\Software\Microsoft\Office\Outlook'
$b = Export-RegTree2 'HKCU:\Software\Microsoft\Office\16.0\Wef\Providers'
$c = Export-RegTree3 'HKCU:\Software\Microsoft\Office\16.0\Outlook'
$d = $a + $b + $c
$d | Export-Clixml "c:\users\$env:username\Regbackup-Outlook-16-Combi.xml" -Force

#start "c:\users\$env:username\"

$combi5 = @{
OfficeOutlook = (Export-RegTree1 'HKCU:\Software\Microsoft\Office\Outlook') ;
WefProviders = (Export-RegTree3 'HKCU:\Software\Microsoft\Office\16.0\Wef\Providers') ;
Outlook160 = (Export-RegTree3 'HKCU:\Software\Microsoft\Office\16.0\Outlook')
}
$combi5 | Export-Clixml "c:\users\$env:username\Regbackup-Outlook-16-Combi-array.xml" -Force

$combi5

<#
start "c:\users\$env:username\Regbackup-Outlook-16-Combi.xml"
#>

<#
$combi5 = @{
OfficeOutlook = (Export-RegTree1 'HKCU:\Software\Microsoft\Office\Outlook') ;
WefProviders = (Export-RegTree3 'HKCU:\Software\Microsoft\Office\16.0\Wef\Providers') ;
Outlook160 = (Export-RegTree3 'HKCU:\Software\Microsoft\Office\16.0\Outlook')
}
$combi5 | Export-Clixml "c:\users\$env:username\Regbackup-Outlook-16-Vcombic.xml" -Force
#>

    #clear
    #$combi5.Outlook160
    #$combi5.WefProviders
    #$combi5.OfficeOutlook


function Import-RegTree([string][ValidateScript({Test-Path $_})]$xmlfile){
    Import-Clixml $xmlfile | %{
        if (!(Test-Path $_.Path)){md $_.Path -Force | out-null}
        New-ItemProperty -Path $_.Path -Name $_.Name -Value $_.Value -PropertyType $_.Type -Force
    }
}



# Import
#Import-RegTree "c:\users\$env:username\Regbackup-Outlook-16-V1c.xml"
#Import-RegTree "c:\users\$env:username\Regbackup-Outlook-16-V2c.xml"
#Import-RegTree "c:\users\$env:username\Regbackup-Outlook-16-V3c.xml"

Import-RegTree "c:\users\$env:username\Regbackup-Outlook-16-Vcombic.xml"

#>
