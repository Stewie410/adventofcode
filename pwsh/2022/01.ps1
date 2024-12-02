[CmdletBinding()]
param(
    [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
    [string]
    $InputFile
)

function Get-Totals($file)
{
    $current = 0
    $list = @()

    switch -Regex -File $file
    {
        '[0-9]'
        {
            $current += [int] $_
        }
        '^\s*$'
        {
            $list += @($current)
            $current = 0
        }
    }

    $list += @($current)

    $list | Sort-Object -Descending
}

function Get-PartA($file)
{
    Get-Totals $file | Select-Object -First 1
}

function Get-PartB($file)
{
    $total = 0

    Get-Totals $file | Select-Object -First 3 | ForEach-Object {
        $total += $_
    }

    return $total
}

Get-PartA $InputFile
Get-PartB $InputFile


