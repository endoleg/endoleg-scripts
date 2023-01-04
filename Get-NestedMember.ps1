function Get-NestedMember {
    <#
    .SYNOPSIS
        Find all Nested members of a group
    .DESCRIPTION
        Find all Nested members of a group
        This script ist based on a script of lazywinadmin! Thanks! https://github.com/lazywinadmin/PowerShell
        This code presents a PowerShell function named Get-NestedMember that can be used to find all nested members of one or more groups in the Active Directory (AD). The function has three parameters:
        GroupName: One or more group names for which to display nested members.
        RelationShipPath: An option to show the path to the nested members.
        MaxDepth: An option to specify how deep the recursion should go when searching for nested members.
        The function performs a loop for each specified group and then retrieves the members of the group using the Get-ADGroupMember command. It then uses a switch statement to check whether the current member is a group or a user. If it is a group, the group's information is displayed and the function is recursively called to find the nested members of the group. If it is a user, the user's information is displayed.
        Note: Make sure you have the appropriate permissions to access the Active Directory and run this code.

    .PARAMETER GroupName
        Specify one or more GroupName to audit
    .PARAMETER RelationShipPath
        Show the relation ship path
    .PARAMETER MaxDepth
        Specify the Max
    .Example
        Get-NestedMember -GroupName TESTGROUP

        This will find all the indirect members of TESTGROUP
    .Example
        Get-NestedMember -GroupName TESTGROUP,TESTGROUP2

        This will find all the indirect members of TESTGROUP and TESTGROUP2
    .Example
        Get-NestedMember TESTGROUP | Group Name | select name, count

        This will find duplicate

#>
    [CmdletBinding()]
    PARAM(
        [String[]]$GroupName,
        [String]$RelationShipPath,
        [Int]$MaxDepth
    )
    TRY {
        $FunctionName = (Get-Variable -Name MyInvocation -Scope 0 -ValueOnly).MyCommand

        Write-Verbose -Message "[$FunctionName] Check if ActiveDirectory Module is available"
        if (-not(Get-Module Activedirectory -ErrorAction Stop)) {
            Write-Verbose -Message "[$FunctionName] Loading ActiveDirectory Module"
            Import-Module -Name ActiveDirectory -ErrorAction Stop
        }

        # Set Depth Counter
        $DepthCount = 1
        FOREACH ($Group in $GroupName) {
            Write-Verbose -Message "[$FunctionName] Group '$Group'"

            # Get the Group Information
            $GroupObject = Get-ADGroup -Identity $Group -ErrorAction Stop

            IF ($GroupObject) {
                Write-Verbose -Message "[$FunctionName] Group '$Group' - Retrieving members"

                # Get the Members of the group
                $GroupObject | Get-ADGroupMember -ErrorAction Stop | ForEach-Object -Process {

                    # Get the name of the current group (to reuse in output)
                    $ParentGroup = $GroupObject.Name


                    # Avoid circular
                    IF ($RelationShipPath -notlike ".\ $($GroupObject.samaccountname) \*") {
                        if ($PSBoundParameters["RelationShipPath"]) {

                            $RelationShipPath = "$RelationShipPath \ $($GroupObject.samaccountname)"

                        }
                        Else { $RelationShipPath = ".\ $($GroupObject.samaccountname)" }

                        Write-Verbose -Message "[$FunctionName] Group '$Group' - Name:$($_.name) | ObjectClass:$($_.ObjectClass)"
                        $CurrentObject = $_
                        switch ($_.ObjectClass) {
                            "group" {
                                # Output Object
                                $CurrentObject | Select-Object Name, SamAccountName, ObjectClass, DistinguishedName, @{Label = "ParentGroup"; Expression = { $ParentGroup } }, @{Label = "RelationShipPath"; Expression = { $RelationShipPath } }

                                if (-not($DepthCount -lt $MaxDepth)) {
                                    # Find Child
                                    Get-NestedMember -GroupName $CurrentObject.Name -RelationShipPath $RelationShipPath
                                    $DepthCount++
                                }
                            }#Group
                            default { $CurrentObject | Select-Object Name, SamAccountName, ObjectClass, DistinguishedName, @{Label = "ParentGroup"; Expression = { $ParentGroup } }, @{Label = "RelationShipPath"; Expression = { $RelationShipPath } } }
                        }#Switch
                    }#IF($RelationShipPath -notmatch $($GroupObject.samaccountname))
                    ELSE { Write-Warning -Message "[$FunctionName] Circular group membership detected with $($GroupObject.samaccountname)" }
                }#ForeachObject
            }#IF($GroupObject)
            ELSE {
                Write-Warning -Message "[$FunctionName] Can't find the group $Group"
            }#ELSE
        }#FOREACH ($Group in $GroupName)
    }#TRY
    CATCH {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
