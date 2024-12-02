[CmdletBinding()]
param(
    [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
    [string]
    $InputFile
)

function Get-PartA($file)
{
    $total = 0

    Get-Content -Path $file | ForEach-Object {
        $r = ($_ -Replace '[AX]', '1' -Replace '[BY]', '2' -Replace '[CZ]', '3').Split(' ')

        $total += [int] $r[1]

        if ('1231'.IndexOf(($r -join '')) -gt 1)
        {
            $total += 6
        } elseif ($r[0] -eq $r[1])
        {
            $total += 3
        }
    }

    return $total
}

function Get-PartB($file)
{
    $total = 0

    Get-Content -Path $Path | ForEach-Object {
        $r = ($_ -Replace 'A', '1' -Replace 'B', '2' -Replace 'C', '3').Split(' ')

        switch ($r[1])
        {
            'X'
            {
                $a = [int] $r[0] - 1

                if ($a -eq 0)
                {
                    $a = 3
                }

                $r[1] = $a.ToString()
            }

            'Y'
            {
                $r[1] = $r[0]
            }

            'Z'
            {
                $a = [int] $r[0] + 1

                if ($a -eq 4)
                {
                    $a = 1
                }

                $r[1] = $a.ToString()
            }
        }

        $total += [int] $r[1]

        if ('1231'.IndexOf(($r -join '')) -gt 1)
        {
            $total += 6
        } elseif ($r[0] -eq $r[1])
        {
            $total += 3
        }
    }

    return $total
}

Get-PartA $InputFile
Get-PartB $InputFile
