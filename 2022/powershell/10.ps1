# 2022-12-10

function Get-PartA($file) {
	$x = 1
	$cycle = 0
	$sum = 0

	Get-Content -Path $file | ForEach-Object {
		$cmd = $_.Split(' ')
		$inc = if ($cmd[1] -eq 'noop') {
			1
		}
		elseif ($cmd[1] -eq 'addx') {
			2
		}

		for ($i = 0; $i -lt $inc; $i++) {
			$cycle++

			if (($cycle - 20) % 40 -eq 0) {
				$sum += $cycle * $x
			}
		}

		if ($inc -eq 2) {
			$x += [int] $cmd[1]
		}
	}

	return $sum
}

function Get-PartB($file) {
	$x = 1
	$cycle = 1
	$crt = 0

	Get-Content -Path $file | ForEach-Object {
		$cmd = $_.Split(' ')
		$inc = if ($cmd[1] -eq 'noop') {
			1
		}
		elseif ($cmd[1] -eq 'addx') {
			2
		}

		for ($i = 0; $i -lt $inc; $i++) {
			$crt += if (@($x, $x + 1, $x + 2) -contains $cycle) {
				'#'
			}
			else {
				'.'
			}

			if ($cycle++ -eq 41) {
				$cycle = 1
				$crt += "`n"
			}
		}

		if ($inc -eq 2) {
			$x += [int] $cmd[1]
		}
	}

	return $crt
}