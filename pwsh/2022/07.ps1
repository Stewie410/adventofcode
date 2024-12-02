[CmdletBinding()]
param(
    [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
    [string]
    $InputFile
)
function Get-FolderHash($file)
{
    $hash = @{}
    $sizes = @{}
    $path = ""

    foreach ($line in (Get-Content -Path $file))
    {
        if ($line -match '^\$ cd')
        {
            switch ($line.Split(' ')[-1])
            {
                '..'
                {
                    if ($path.Length -gt 1)
                    {
                        $path = Split-Path -Path $path -Parent
                    }
                }

                '/'
                {
                    $path = '/'
                }

                default
                {
                    if ($path -eq '/')
                    {
                        $path = $path + $_
                    } else
                    {
                        $path = Join-Path -Path $path -ChildPath $_
                    }
                }
            }

            $path = $path.Replace('\', '/')

            if (!($hash.Keys -contains $path))
            {
                $hash.Add($path, 0)
                $sizes.Add($path, 0)
            }
        } elseif ($line -match '^\d+')
        {
            $hash[$path] += [int] $line.Split(' ')[0]
        }
    }

    foreach ($i in $hash.Keys)
    {
        foreach ($j in $hash.Keys)
        {
            if ($j -match "^$i")
            {
                $sizes[$i] += $hash[$j]
            }
        }
    }

    return $sizes
}

function Get-PartA($file)
{
    $tree = Get-FolderHash $file
    $total = 0

    foreach ($key in $tree.Keys)
    {
        if ($tree[$key] -le 100000)
        {
            $total += $tree[$key]
        }
    }

    return $total
}

function Get-PartB($file)
{
    $tree = Get-FolderHash $file
    $capacity = 70000000 - $tree['/']

    foreach ($key in $tree.Keys)
    {
        if ($capacity + $tree[$key] -ge 30000000)
        {
            if (($null -eq $candidate) -or ($tree[$key] -lt $tree[$candidate]))
            {
                $candidate = $key
            }
        }
    }

    return $tree[$candidate]
}

Get-PartA $InputFile
Get-PartB $InputFile
