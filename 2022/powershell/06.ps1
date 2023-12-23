# 2022-12-06

function Test-UniqueCharacters($string) {
	for ($j = 0; $j -lt $string.Length; $j++) {
		if ($string.Substring($j + 1).ToCharArray() -contains $string.Substring($j, 1)) {
			return $False
		}
	}

	return $True
}

function Get-Markers($file, $length) {
	$markers = @()

	Get-Content -Path $file | ForEach-Object {
		for ($i = 0; $i -lt $_.Length; $i++) {
			if (Test-UniqueCharacters -String $_.Substring($i, $length)) {
				$markers += $i + $length
				break
			}
		}
	}

	return $markers
}

function Get-PartA($file) {
	Get-Markers $file 4
}

function Get-PartB($file) {
	Get-Markers $file 14
}