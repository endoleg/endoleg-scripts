# source: https://www.msxfaq.de/code/powershell/psperfcounter.htm

function Get-LocalPerfCounterName {

   param (
      [Parameter(Mandatory=$true)]
      $Name
    )

   $key009 = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib\009'
   $counters009 = (Get-ItemProperty -Path $key009 -Name Counter).Counter.tolower()
   $Index = $counters009.IndexOf($name.tolower())
   if ($index -eq -1) {
      $null   # not found
   }
   else {
      $keylocal = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib\CurrentLanguage'
      $counterslocal = (Get-ItemProperty -Path $keylocal -Name Counter).Counter
      $counterslocal[$index]
   }
}

# Get CPU Load with local Perfmon names

# Normal localized Version
#(get-counter "\prozessor(_total)\prozessorzeit (%)").countersamples.cookedValue

# Get CPU Load using english names as source
$counter="Processor"
$Subcounter = "% Processor Time"
$instance = "_Total"

(get-counter "\$(get-LocalPerfCounterName $counter)($($instance))\$(get-LocalPerfCounterName $subcounter)").countersamples.cookedValue
