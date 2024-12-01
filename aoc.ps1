<#
.SYNOPSIS
Powershell AOC Solution Runner

.DESCRIPTION
Powershell AOC Solution Runner

.PARAMETER Date
Specify the day's solution to be executed

.PARAMETER File
Specify input file

.PARAMETER Year
Specify the year's solutions to be executed

.PARAMETER Part
Get either part "A" or "B" solution

#>

[CmdletBinding(DefaultParameterSetName = 'Default')]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidatePattern('(0?[1-9]|1[0-9]|2[0-5])')]
    [int]
    $Date,

    [Parameter(Mandatory, Position = 1)]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string]
    $File,

    [Parameter()]
    [PSDefaultValue(Help = 'Current Year')]
    [int]
    $Year = (Get-Date).Year,

    [Parameter()]
    [ValidateScript({ $_.ToLower() -match '([ab]|both)' })]
    [PSDefaultValue(Help = 'Both')]
    [string]
    $Part = "both"
)

function Invoke-Main {
    $root = Split-Path -Path $PSCommandPath -Parent
    $slns = Join-Path -Path $root -ChildPath $Year | Join-Path -ChildPath "powershell"
    $day = if ($Date -lt 10) { "0$Date" } else { "$Date" }

    if (!(Test-Path -Path $slns -PathType Container)) {
        Write-Error -Message "No solutions for the specified year: $Year" -ErrorAction Stop
    }

    if (!(Test-Path -Path (Join-Path -Path $slns -ChildPath "$day.ps1") -PathType Leaf)) {
        Write-Error -Message "No solution for date: $Year-$day" -ErrorAction Stop
    }

    . (Join-Path 0Path $slns -ChildPath "$day.ps1")

    switch ($Part.ToLower()) {
        'a' {
            if (Get-Command -Name 'Get-PartA' -ErrorAction SilentlyContinue | Out-Null) {
                Get-PartA $File
            } else {
                (Get-Solution $File)[0]
            }
        }
        'b' {
            if (Get-Command -Name 'Get-PartB' -ErrorAction SilentlyContinue | Out-Null) {
                Get-PartB $File
            } else {
                (Get-Solution $File)[1]
            }
        }
        default {
            Get-Solution $File
        }
    }
}

Invoke-Main
