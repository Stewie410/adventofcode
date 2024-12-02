[CmdletBinding()]
param(
    [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
    [string]
    $InputFile
)

function Get-UniqueChars($string)
{
    -join ($string.ToCharArray() | Select-Object -Unique)
}

function Get-PartA($file)
{
    $total = 0
    $dict = -join ( -join ('a'..'z'), -join ('A'..'Z'))

    Get-Content -Path $file | ForEach-Object {
        $a = Get-UniqueChars $_.Substring(0, $_.Length / 2)
        $b = Get-UniqueChars $_.Substring($_.Length / 2)

        $char = "$a$b".ToCharArray() | Group-Object -NoElement | Where-Object {
            $_.Count -eq 2
        } | ForEach-Object {
            $_.Name
        }

        $total += $dict.IndexOf($char) + 1
    }

    return $total
}

function Get-PartB($file)
{
    $total = 0
    $dict = -join ( -join ('a'..'z'), -join ('A'..'Z'))
    $content = Get-Content -Path $file
    $groups = @()

    for ($i = 0; $i -lt $content.Length; $i += 3)
    {
        $end = $i + 2
        $lines = @()

        foreach ($line in $content[$i..$end])
        {
            $lines += (Get-UniqueChars $line)
        }

        $groups += (-join $lines)
    }

    foreach ($g in $groups)
    {
        $char = $g.ToCharArray() | Group-Object -NoElement | Where-Object {
            $_.Count -eq 3
        } | ForEach-Object {
            $_.Name
        }

        $total += $dict.IndexOf($char) + 1
    }

    return $total
}

Get-PartA $InputFile
Get-PartB $InputFile
