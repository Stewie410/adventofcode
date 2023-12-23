# 2022-12-09

function Get-Increment($a, $b) {
	$inc = if ($a -lt $b) {
		-1
	}
 elseif ($a -gt $b) {
		1
	}
 else {
		0
	}

	return $inc
}

function Move-Knots([ref]$knots, [ref]$steps) {
	for ($j = 1; $j -lt $knots.Value.Length; $j++) {
		$head = $knots.Value[($j - 1)]
		$tail = $knots.Value[$j]

		while (([Math]::Abs($head[0] - $tail[0]) -gt 1) -or ([Math]::Abs($head[1] - $tail[1]) -gt 1)) {
			$knots.Value[$j][0] += Get-Increment $head[0] $tail[0]
			$knots.Value[$j][1] += Get-Increment $head[1] $tail[1]

			if ($knots.Value.Length - 1 -eq $j) {
				$steps.Value[($knots.Value[-1] -join ',')] = 1
			}
		}
	}
}

function Get-PartA($file) {
	$knots = [int[][]]::new(2, 2)
	steps = @{ '0,0' = 1 }

	Get-Content -Path $file | ForEach-Object {
		$move = $_.Split(' ')

		switch ($move[0].ToUpper()) {
			'U' {
				$knots[0][1] -= [int] $move[1]
			}

			'D' {
				$knots[0][1] += [int] $move[1]
			}

			'L' {
				$knots[0][0] -= [int] $move[1]
			}

			'R' {
				$knots[0][0] += [int] $move[1]
			}
		}

		Move-Knots ([ref] $knots) ([ref] $steps)
	}

	return @($steps.Keys).Length
}

function Get-PartB($file) {
	$knots = [int[][]]::new(2, 2)
	steps = @{ '0,0' = 1 }

	Get-Content -Path $file | ForEach-Object {
		$move = $_.Split(' ')

		for ($i = 1; $i -le [int] $move[1]; $i++) {
			switch ($move[0].ToUpper()) {
				'U' {
					$knots[0][1]--
				}

				'D' {
					$knots[0][1]++
				}

				'L' {
					$knots[0][0]--
				}

				'R' {
					$knots[0][0]++
				}
			}

			Move-Knots ([ref] $knots) ([ref] $steps)
		}
	}

	return @($steps.Keys).Length
}