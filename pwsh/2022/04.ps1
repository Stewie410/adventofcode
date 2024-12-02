[CmdletBinding()]
param(
    [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
    [string]
    $InputFile
)

function Get-Points($string)
{
    [Regex]::Split($Line, '[,\-]') | ForEach-Object {
        [int] $_
    }
}

function Get-PartA($file)
{
    $content = Get-Content -Path $file | ForEach-Object {
        $points = Get-Points $_
        if (($points[0] -le $points[2]) -and ($points[1] -ge $points[3]))
        {
            $_
        } elseif (($points[0] -ge $points[2]) -and ($points[1] -le $points[3]))
        {
            $_
        }
    }

    return $content.Length
}

function Get-PartB($file)
{
    $content = Get-Content -Path $file | ForEach-Object {
        $points = Get-Points $_
        if (($points[0] -le $points[2]) -and ($points[1] -ge $points[2]))
        {
            $_
        } elseif (($points[0] -ge $points[2]) -and ($points[0] -le $points[3]))
        {
            $_
        }
    }

    return $content.Length
}

Get-PartA $InputFile
Get-PartB $InputFile
