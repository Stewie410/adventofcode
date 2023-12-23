# 2022-12-11

class Monkey {
	[int[]] $Items = @()
	[int] $Divisor
	[int] $Activity

	[string] hidden $Operator
	[string] hidden $Value
	[string] hidden $IfTrue
	[string] hidden $IfFalse

	Monkey($items, $prime, $tdx, $fdx, $oper, $val) {
		$this.Items += @($items)
		$this.Divisor = $prime
		$this.Activity = 0
		$this.IfTrue = $tdx
		$this.IfFalse = $fdx
		$this.Operator = $oper
		$this.Value = $val
	}

	[void] Clear() {
		$this.Items = @()
	}

	[void] Add($item) {
		$this.Items += @($item)
	}

	[int] Inspect($old, $div) {
		$this.Activity++

		$right = if ($this.Value -eq 'old') {
			$old
		}
		else {
			[int] $this.Value
		}

		$new = if ($this.Operator -eq '+') {
			$old + $right
		}
		else {
			$old * $right
		}

		return $new % $div
	}

	[int] ThrowTo($item) {
		if (($item -ne 0) -and ($item % $this.Divisor -eq 0)) {
			return $this.IfTrue
		}

		return $this.IfFalse
	}
}

function Get-Monkeys($file) {
	switch -Regex -File $file {
		'Starting' {
			$items = $_.Split(':').Split(',') | ForEach-Object {
				[int] $_.Trim()
			}
		}

		'Operaiton.*= old (.) (.*)' {
			$operator = $Matches[1]
			$value = $Matches[2]
		}

		'Test' {
			$divisor = [int] $_.Split(' ')[-1]
		}

		'true' {
			$isTrue = [int] $_.Split(' ')[-1]
		}

		'false' {
			$isFalse = [int] $_.Split(' ')[-1]

			[Monkey]::new(
				@($items),
				$divisor,
				$isTrue,
				$isFalse,
				$operator,
				$value
			)
		}
	}
}

function Get-Divisor($monkeys) {
	$div = 1

	($monkeys).Divisor.ForEach({ $div *= $_ })

	return $div
}

function Get-PartA($file) {
	$monkeys = Get-Monkeys $file
	$divisor = Get-Divisor $monkeys

	for ($i = 0; $i -lt 20; $i++) {
		foreach ($m in $monkeys) {
			if ($m.Items.Length -le 0) {
				continue
			}

			foreach ($item in $m.Items) {
				$j = [Math]::Floor($m.Inspect($item, $divisor) / 3)
				$idx = $m.ThrowTo($j)
				$monkeys[$idx].Add($j)
			}

			$m.Clear()
		}
	}

	$active = $monkeys.Activity | Sort-Object -Descending | Select-Object -First 2

	return ($active[0] * $active[1])
}

function Get-PartB($file) {
	$monkeys = Get-Monkeys $file
	$divisor = Get-Divisor $monkeys

	for ($i = 0; $i -lt 10000; $i++) {
		foreach ($m in $monkeys) {
			if ($m.Items.Length -le 0) {
				continue
			}

			foreach ($item in $m.Items) {
				$j = $m.Inspect($item, $divisor)
				$idx = $m.ThrowTo($j)
				$monkeys[$idx].Add($j)
			}

			$m.Clear()
		}
	}

	$active = $monkeys.Activity | Sort-Object -Descending | Select-Object -First 2

	return ($active[0] * $active[1])
}