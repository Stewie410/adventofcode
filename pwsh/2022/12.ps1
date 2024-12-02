[CmdletBinding()]
param(
    [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
    [string]
    $InputFile
)

function Get-HeightMap($file)
{
    $content = Get-Content -Path $file
    $map = [int[][]]::new($content.Length, $content[0].Length)
    $start = $null
    $end = $null

    for ($y = 0; $y -lt $content.Length; $y++)
    {
        $chars = $content[$y].ToCharArray()

        for ($x = 0; $x -lt $content[0].Length; $x++)
        {
            $char = $chars[$x]

            switch -CaseSensitive ("$char")
            {
                'S'
                {
                    $start = [Tuple]::Create($y, $x)
                    $char = [char] 'a'
                }

                'E'
                {
                    $end = [Tuple]::Create($y, $x)
                    $char = [char] 'z'
                }
            }

            $map[$y][$x] = ([Convert]::ChangeType($char, [int])) - 97
        }
    }

    return [PSCustomObject]@{
        Map   = $map
        Start = $start
        End   = $end
    }
}

function Get-Steps($file)
{
    $parsed = Get-HeightMap $file

    $p1 = $p2 = $null
    $visited = @()

    $map = $parsed.Map
    $width = $map[0].Length
    $height = $map.Length

    $q = [Collections.Queue]::new(1)
    $q.Enqueue([Tuple]::Create(0, $map.End.Item1, $map.End.Item2))

    while ($True)
    {
        $node = $q.Dequeue()
        $tag = ',' -join @($node.Item2, $node.Item3)

        if ($visited -contains $tag)
        {
            continue
        }

        $visited += @($tag)

        if (($null -eq $p1) -or ($null -eq $p2))
        {
            if ($null -eq $p1)
            {
                if (($node.Item2 -eq $map.Start.Item1) -and ($node.Item3 -eq $map.Start.Item2))
                {
                    $p1 = $node.Item1
                }
            }
            if ($null -eq $p2)
            {
                if (map[$node.Item2][$node.Item3] -eq 0)
                {
                    $p2 = $node.Item1
                }
            }
        } else
        {
            return [PSCustomObject]@{
                A = $p1
                B = $p2
            }
        }

        $pairs = @{
            N = [PSCustomObject]@{
                X = $node.Item3
                Y = $node.Item2 - 1
            }

            S = [PSCustomObject]@{
                X = $node.Item3
                Y = $node.Item2 + 1
            }

            W = [PSCustomObject]@{
                X = $node.Item3 - 1
                Y = $node.Item2
            }

            E = [PSCustomObject]@{
                X = $node.Item3 + 1
                Y = $node.Item2
            }
        }

        foreach ($k in $pairs.Keys)
        {
            if (($pairs[$k].X -lt 0) -or ($pairs[$k].X -ge $width))
            {
                continue
            } elseif (($pairs[$k].Y -lt 0) -or ($pairs[$k].Y -ge $height))
            {
                continue
            } elseif ($map[$pairs[$k].Y][$pairs[$k].X] -ge ($map[$node.Item2][$node.Item3] - 1))
            {
                $q.Enqueue([Tuple]::Create($node.Item1 + 1, $pairs[$k].Y, $pairs[$k].X))
            }
        }
    }
}

Get-Steps $InputFile
