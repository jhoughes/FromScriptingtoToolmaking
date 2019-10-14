#region Presentation Info

<#
    From Scripting to Toolmaking: Taking the Next Step with PowerShell
    Presented at SpiceWorld 2019   (Thanks SpiceHeads!!)
    Presenter:  Joe Houghes
    Blog: https://www.fullstackgeek.net
    Twitter: @jhoughes
#>

#endregion

#region Prevent the script from running via fat-finger

throw "Don't fat finger and run the whole script Joe"

<#
    Stole this code from Mike Robbins (@mikefrobbins), who borrowed it from Thomas Rayner (@MrThomasRayner).
    For more information, see:
    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/
#>

#endregion

#region Setting things properly

#Set PowerShell ISE Zoom to 175%
$psISE.Options.Zoom = 175

<#
    Presentation Tip: when using the #PowerShell console, modify the error color for better
    readability AND audience members with Color Blindness. - Michael Bender
    https://twitter.com/MichaelBender/status/983485482423078913
#>

#Set error messages to yellow
$host.PrivateData.ErrorForegroundColor = 'yellow'

#Set location
$Path = 'C:\Demo'
if (-not(Test-Path -Path $Path -PathType Container)) {
    New-Item -Path $Path -ItemType Directory | Out-Null
}
Set-Location -Path $Path

#Clear the screen
Clear-Host

#endregion

#region Demo Environment

<#
    This code is running on a Windows 10 machine with PowerShell 5.1.
    I've left it generic enough that it should run on older versions of Windows
    or PowerShell, but your mileage may vary.
#>

#endregion

#region Intro

#   PowerPoint Slide 4

#endregion

#region Agenda

#   PowerPoint Slide 5

#endregion

#region Who's in the audience?

#   PowerPoint Slide 7

#endregion

#region Challenged Faced By Customers

#   PowerPoint Slide 8

#endregion

#region Maintaining Control with Tools

#   PowerPoint Slide 9

#endregion

#region Start With A Plan

#   PowerPoint Slide 11

#endregion

#region Basics of a Toolmaking Plan

#   PowerPoint Slide 12

#endregion

#region Don’t forget the PowerShell Basics

#   PowerPoint Slide 13

#endregion

#region Script or Function

#   PowerPoint Slide 15

#endregion

#region Proper Function Naming & Conventions

#   PowerPoint Slide 16

#Function Naming

#Use approved verbs, singular nouns and Pascal case for function name.
#This should be carried through to variable names for ease of reading.
#Model after the Windows built-in cmdlets for examples: Get-Service, Get-Process, Get-ChildItem

Get-Verb | Sort-Object -Property Verb | Out-GridView

#An example of a very basic function

function Get-PSVersion {
    $PSVersionTable.PSVersion
}

Get-PSVersion

#If you are creating functions to mimic built-in functionality, add a prefix to the noun using something unique - like your initials or org short name.

function Get-JHPSVersion {
    $PSVersionTable.PSVersion
}

Get-JHPSVersion

#Do not use PS as a prefix, or other prefixes which may match other mainstream tools that you use.
#Examples: Windows, VM, Host, AD, Azure/Az, UCS, AWS, etc.

#Just be consistent in what you use, it makes these functions easier to locate.

#Read the help topic "about_Functions -Full"

#Parameter naming
#Model after the parameter names used in Windows built-in cmdlets for examples: Get-Service, Get-Process, Get-ChildItem

function New-FunctionParameter {

    param (
        $ComputerName
    )

    Write-Output $ComputerName

}

New-FunctionParameter -ComputerName Computer1, Computer2

#Stick with standarized names which users are expecting from default Windows cmdlets

function Get-ParameterNameCount {
    param (
        [string[]]$ParameterName
    )

    foreach ($Parameter in $ParameterName) {
        $Results = Get-Command -ParameterName $Parameter -ErrorAction SilentlyContinue

        [pscustomobject]@{
            ParameterName   = $Parameter
            CmdletCount = $Results.Count
        }
    }
}

Get-ParameterNameCount -ParameterName ComputerName, Server, Computer, Name, Host, System, VM, ID

#We are still running only a basic function at this point

function New-FunctionParameter {

    param (
        $ComputerName
    )

    Write-Output $ComputerName

}

#Nothing exists beyond what we explicitly defined, let's run these lines to confirm:

New-FunctionParameter -

Get-Command -Name New-FunctionParameter -Syntax
(Get-Command -Name New-FunctionParameter).Parameters.Keys

#Read the help topic "about_Functions_Advanced_Parameters -Full"

#PSScript Analyzer - https://github.com/PowerShell/PSScriptAnalyzer
#Automatically included in VSCode if you install the PowerShell extension

#Source code checker for PowerShell modules and scripts; checks the quality of PowerShell code by running a
#set of rules based on PowerShell best practices identified by the PowerShell Team and the community.

#The Unofficial PowerShell Best Practices and Style Guide - https://github.com/PoshCode/PowerShellPracticeAndStyle

#endregion

#region Advanced Functions Best Practices

#   PowerPoint Slide 17

#To create an advanced function, just add CmdletBinding and now you have an advanced function

function Test-BasicCmdletBinding {
    
    #This is the only line required to make this into an advanced function
    [CmdletBinding()] 
    param (
        $ComputerName
    )

    Write-Output $ComputerName

}

#This adds common parameters. CmdletBinding does require a param block, but the param block can be empty.

Test-BasicCmdletBinding -

#Show there are now additional (common) parameters

Get-Command -Name Test-BasicCmdletBinding -Syntax
(Get-Command -Name Test-BasicCmdletBinding).Parameters.Keys

<#Common parameters:

-Verbose
-Debug
-ErrorAction
-WarningAction
-ErrorVariable
-WarningVariable
-OutVariable
-OutBuffer
-PipeLineVariable

#>

#Read the help topic: "about_CommonParameters -Full"
#Read the help topic: "about_Functions_CmdletBindingAttribute -Full"
#Read the help topic: "about_Functions_Advanced -Full"

#Adding Comment based help

function Get-VeeamHistoricalBackupSize {

    <#
.SYNOPSIS
    Simple Veeam report to give details of source data & backup size per backup file/repository.
 
.DESCRIPTION
    Get-VeeamHistoricalBackupSize is a function that will query the details of backup jobs,
    backups on disk, and backup respoitory details to display details about the source data and
    backup file sizes on a per file & per backup repository basis.
 
.PARAMETER ComputerName
    The backup server to query for backup details.

.PARAMETER Credential
    Specifies an account which has administrative permission to query Veeam backup data. The default
    is the current user.
 
.EXAMPLE
    Get-VeeamHistoricalBackupSize -ComputerName 'Server1', 'Server2'

.EXAMPLE
    'Server1', 'Server2' | Get-VeeamHistoricalBackupSize

.EXAMPLE
    Get-VeeamHistoricalBackupSize -ComputerName 'Server1', 'Server2' -Credential (Get-Credential)
 
.INPUTS
    String
 
.OUTPUTS
    PSCustomObject
 
.NOTES
    Version: 1.0
    Author: Joe Houghes
    Email: joe.houghes@veeam.com
    Modified Date: 9-6-2019
#>

    [CmdletBinding()]
    param (
    
    )

    #Function Body

}

help Get-VeeamHistoricalBackupSize -Full


#Leverage snippets for this, built into ISE (Press Ctrl + J)
#Check out other resources for adding to VSCode:

#https://github.com/PowerShell/vscode-powershell/blob/master/snippets/PowerShell.json
#https://github.com/PowerShell/vscode-powershell/blob/master/docs/community_snippets.md
#https://gist.github.com/rkeithhill/60eaccf1676cf08dfb6f
#https://github.com/fatherjack/vscode-snippets/blob/master/powershell.json


#Perform a single task, then connect your functions together

Get-Data | Set-Data | Write-Data

#Also remember that data should not be persistent in your functions or scripts (with an upcoming exception).
#If your data needs to be persistent, get it out of PowerShell.

#If nothing else, write to a flat file (think PowerShell transcript).
#For ease of use, consider XML with native PowerShell functionality or JSON.
#For best performance and stability, use a database.

#Error Handling 

#Setting $ErrorActionPreference is not an acceptable practice.
#Use a try/catch block where you may encounter an error.
#Since you can only catch terminating errors, so force them even from non-terminating errors.
#If you need to modify a single command in a pipeline for unique instances, leverage the -ErrorAction paramater for that single command instead.

function Test-ErrorHandling {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName
    )

    PROCESS {
        foreach ($Computer in $ComputerName) {
            Test-WSMan -ComputerName $Computer
        }
    }

}

Test-ErrorHandling -ComputerName Offline, DoesNotExist, PNTLSLAB

#Only adding a try/catch block doesn't fix the issue, because we're still facing a non-terminating error.

function Test-ErrorHandlingTC {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName
    )

    PROCESS {
        foreach ($Computer in $ComputerName) {
            try {
                Test-WSMan -ComputerName $Computer
            }
            catch {
                Write-Warning -Message "Unable to connect to computer: $Computer. Verify that is is online & accessible via WimRM."
            }
        }
    }

}

Test-ErrorHandlingTC -ComputerName DoesNotExist

#By adding the -ErrorAction parameter and specifying a Stop action, this makes a non-terminating error into a terminating error.

function Test-ErrorHandlingFull {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName
    )

    PROCESS {
        foreach ($Computer in $ComputerName) {
            try {
                Test-WSMan -ComputerName $Computer -ErrorAction Stop
            }
            catch {
                Write-Warning -Message "Unable to connect to computer: $Computer. Verify that is is online & accessible via WimRM."
            }
        }
    }

}

Test-ErrorHandlingFull -ComputerName DoesNotExist

#Read the help topic: "about_Try_Catch_Finally"
#Additonal topic: https://jamesone111.wordpress.com/2019/01/30/powershell-dont-just-throw/

#endregion

#region Recommendations for Functions 

#   PowerPoint Slide 18

#Requires Statement
#Use #requires statements to ensure that the session environment is correct

<#
#Requires -Version <N>[.<n>]
#Requires -PSSnapin <PSSnapin-Name> [-Version <N>[.<n>]]
#Requires -Modules { <Module-Name> | <Hashtable> }
#Requires -ShellId <ShellId>
#Requires -RunAsAdministrator
#>

#Read the help topic: "about_Requires"

function Test-VerboseOutput {
    
    [CmdletBinding()]
    param (
        [string[]]$ComputerName = $env:COMPUTERNAME
    )

    foreach ($Computer in $ComputerName) {
        #Doing a thing against $Computer
        Write-Output $Computer
    }

}

Test-VerboseOutput -ComputerName Computer1, Computer2 -Verbose

#Leverage Write-Verbose instead of inline comments, this will also allow you to see what steps your code is running through, when necessary or desired

function Test-VerboseOutput {
    
    [CmdletBinding()]
    param (
        [string[]]$ComputerName = $Env:COMPUTERNAME
    )

    foreach ($Computer in $ComputerName) {
        Write-Verbose -Message "Doing a thing against $Computer"
        Write-Output $Computer
    }

}

Test-VerboseOutput -ComputerName Computer1, Computer2
Test-VerboseOutput -ComputerName Computer1, Computer2 -Verbose

#SupportsShouldProcess

function Test-SupportsShouldProcess {
    
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $ComputerName
    )

    Write-Output $ComputerName

}

#Updating your CmdletBinding statement to this adds the -Confirm and -WhatIf parameters.
#You really only need this as an option if your function will be making changes.

#Show that we now have -Confirm and -WhatIf parameters.

Test-SupportsShouldProcess -

#Well-defined parameters

<#
1. Type your parameters, specify any whic are mandatory, add a help message.
2. Define aliases for your parameters for easier integration with other cmdlets/data exports.
3. Add validation for your parameters - ValidateCount, ValidateLength, ValidateRange, ValidateNotNull, ValidateNotNullOrEmpty, ValidateSet, ValidatePattern
4. Consider parameter sets to set parameters to be exclusive if they cannot be run concurrently.
5. Pipeline input - be careful with this when beginning with writing functions, you will write more code, and must write your code to be capable of handling single/multiple objects.
    #Believe it or not, this is not as easy as it sounds.
#>

Function Get-SystemInfo {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, HelpMessage = "Enter the name of system to gather infomation.")]
        [Alias("HostName","CN","ServerName")]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName
    )

    Write-Verbose "Gathering server information for all computers"

    foreach ($Computer in $Comp) {
        Write-Output $ComputerName
    }
}


#Parameter Set

Function Get-SystemInfo {

    Param(
        [Parameter(Mandatory=$true,
        ParameterSetName="Computer")]
        [String[]]
        $ComputerName,

        [Parameter(Mandatory=$true,
        ParameterSetName="User")]
        [String[]]
        $UserName,

        [Parameter(Mandatory=$false, ParameterSetName="Computer")]
        [Parameter(Mandatory=$true, ParameterSetName="User")]
        [Switch]
        $Summary
    )

    #Only showing param block for visualization of parameter set
}

#Read the help topic: "about_Functions_Advanced_Parameters"

#Never test your code in an editor or within a session running any profile
#Always test your code using Powershell.exe -NoProfile, you can even run this within an existing PowerShell session
#You should also use Pwsh.exe -NoProfile, if you are creating cross-platform tools
#You may want to look into Pester or Appveyor for advanced testing, or if you are starting a CI/CD pipeline for development.

#endregion

#region Controller Scripts

#   PowerPoint Slide 20

#For a great example of a controller script, check out vCheck. At first script launch, it walks you through a menu to build your specific variables/values, then uses that to run the other modules.
#https://github.com/alanrenouf/vCheck-vSphere

#endregion

#region What Comes Next - After You Ship (Next Steps for Functions)

#   PowerPoint Slide 21 & 22

#endregion

#region Tips to Cheat and Steal; Really, Borrow – and Give Credit (Additional Resources)

#   PowerPoint Slide 24

<#
Jeff Hicks' POWERSHELL SCRIPTING AND TOOLMAKING TRAPS Session (SpiceWorld 2019) - https://github.com/jdhitsolutions/PowerShellScriptingTraps

PowerShell.org YouTube Channel:
Functions/Toolmaking - Don Jones Toolmaking (3 videos)
https://youtu.be/KprrLkjPq_c
https://youtu.be/U849a17G7Ro
https://youtu.be/GXdmjCPYYNM

Proxy Functions - Jeff Hicks - Accelerated Toolmaking
https://youtu.be/zWh4Y_7lNBg

Optimizing Performance – Joshua King - Whip Your Scripts into Shape
https://youtu.be/Yp_m5T_kyJU

eBooks:
The PowerShell Scripting & Toolmaking Book – Don Jones/Jeff Hicks
https://leanpub.com/powershell-scripting-toolmaking

Learn Windows PowerShell in a Month of Lunches, Third Edition 
https://www.manning.com/books/learn-windows-powershell-in-a-month-of-lunches-third-edition

Learn PowerShell Toolmaking in a Month of Lunches
https://www.manning.com/books/learn-powershell-toolmaking-in-a-month-of-lunches

Learn PowerShell Scripting in a Month of Lunches 
https://www.manning.com/books/learn-powershell-scripting-in-a-month-of-lunches

The PowerShell Best Practices and Style Guide
https://github.com/PoshCode/PowerShellPracticeAndStyle

Free eBook on PowerShell Advanced Functions
http://mikefrobbins.com/2015/04/17/free-ebook-on-powershell-advanced-functions/

Mastering PowerShell ebook
https://www.idera.com/resourcecentral/whitepapers/powershell-ebook

PowerShell.org Books (DevOps Collective)
https://leanpub.com/u/devopscollective

Jeff Hicks' Recommended Books & Training:
https://jdhitsolutions.com/blog/books-and-training/

ATXPowerShell YouTube Channel:
Debugging PowerShell in VSCode w/Josh Duffney
https://youtu.be/Kg5eKslokao

Modules (GitHub)
PSKoans – Learn PowerShell through Pester
https://github.com/vexx32/PSKoans

Plaster – “Scaffolding” of modules, Pester tests, DSC configs, etc.
https://github.com/PowerShell/Plaster

PlatyPS – Write PowerShell External Help in Markdown
https://github.com/PowerShell/platyPS

Aggregated PowerShell Community sites/blogs:
https://www.planetpowershell.com/

Additional Curated Resource Lists:
http://jdhitsolutions.com/blog/essential-powershell-resources/

#>



#endregion

#Thanks all, have a great day and close to SpiceWorld 2019!
#Come up front for free swag