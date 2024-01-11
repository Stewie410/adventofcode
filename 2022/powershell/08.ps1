# 2022-12-08

function Get-Solutions($file) {
	$forest = @()

	Get-Content -Path $file | ForEach-Object {
		$trees = $_ -split '(\d)' | Where-Object {
			$_
		} | ForEach-Object {
			[int] $_
		}

		$forest += , @($trees)
	}

	$visible = 2 * ($forest[0].Length - 2 + $forest.Length)
	$max = 0

	for ($y = 1; $y -lt $forest.Length - 1; $y++) {
		$row = $forest[$y]

		for ($x = 1; $x -lt $forest[0].Length - 1; $x++) {
			$score = 1
			$tree = $row[$x]
			$col = $forest | ForEach-Object { $_[$x] }
			$parts = @{
				'u' = [PSCustomObject]@{
					Array   = $col[($y - 1)..0]
					Score   = 0
					Visible = $True
				}

				'd' = [PSCustomObject]@{
					Array   = $col[($y + 1)..$col.Length]
					Score   = 0
					Visible = $True
				}

				'l' = [PSCustomObject]@{
					Array   = $row[($x - 1)..0]
					Score   = 0
					Visible = $True
				}

				'r' = [PSCustomObject]@{
					Array   = $row[($x + 1)..$row.Length]
					Score   = 0
					Visible = $True
				}
			}

			foreach ($i in $parts.Keys) {
				foreach ($j in $parts[$i].Array) {
					$parts[$i].Score++

					if ($j -ge $tree) {
						$parts[$i].Visible = $False
						break
					}
				}
				$score *= $parts[$i].Score
			}

			if ($score -gt $max) { $max = $score }

			if (($parts.Values).Visible -contains $True) { $visible++ }
		}
	}

	return [PSCustomObject]@{
		Visible = $visible
		Max     = $max
	}
}

function Get-PartA($file) {
	return (Get-Solutions $file).Visible
}

function Get-PartB($file) {
	return (Get-Solutions $file).Max
}