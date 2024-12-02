[CmdletBinding()]
param(
    [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
    [string]
    $InputFile
)

filter Format-ReverseString
{
    $arr = $_.ToCharArray()
    [Array]::Reverse($arr)
    -join $arr
}

function Get-Stacks($content)
{
    $filtered = $content | Where-Object { $_ -match '\[' }
    $list = [string[]]::new(($filtered[-1] -split '(.{4})').Length)

    foreach ($line in $filtered)
    {
        $fields = $line -split '(.{4})'

        for ($i = 0; $i -lt $fields.Length; $i++)
        {
            if ($fields[$i] -match '\[[A-Z]\]')
            {
                $list[$i] += $fields[$i] -Replace '[^A-Z]', ''
            }
        }
    }

    $list | Where-Object { $null -ne $_ }
}

function Get-Moves($content)
{
    $content | Where-Object {
        $_ -match 'move'
    } | ForEach-Object {
        $parts = $_ -split '\s+'

        [PSCustomObject]@{
            Count = [int] $parts[1]
            From  = [int] $parts[3] - 1
            To    = [int] $parts[5] - 1
        }
    }
}

function Get-PartA($file)
{
    $content = Get-Content -Path $file
    $stacks = Get-Stacks $content

    foreach ($move in (Get-Moves -Content $content))
    {
        $prepend = $stacks[$move.From].Substring(0, $move.Count) | Format-ReverseString
        $stacks[$move.To] = $prepend + $stacks[$move.To]
        $stacks[$move.From] = $stacks[$move.From].Substring($move.Count)
    }

    -join ($stacks | ForEach-Object {
            $_.Substring(0, 1)
        })
}

function Get-PartB($file)
{
    $content = Get-Content -Path $file
    $stacks = Get-Stacks -Content $content

    foreach ($move in (Get-Moves -Content $content))
    {
        $prepend = $stacks[$move.From].Substring(0, $move.Count)
        $stacks[$move.To] = $prepend + $stacks[$move.To]
        $stacks[$move.From] = $stacks[$move.From].Substring($move.Count)
    }

    -join ($stacks | ForEach-Object {
            $_.Substring(0, 1)
        })
}

Get-PartA $InputFile
Get-PartB $InputFile
