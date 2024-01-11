#!/usr/bin/env bash

solution() {
    local -A lookup
    local -a sums
    local line rgx nums first last

    rgx='(zero|one|two|three|four|five|six|seven|eight|nine|[0-9])'
    local -A lookup=(
        ['0']='0'   ['zero']='0'
        ['1']='1'   ['one']='1'
        ['2']='2'   ['two']='2'
        ['3']='3'   ['three']='3'
        ['4']='4'   ['four']='4'
        ['5']='5'   ['five']='5'
        ['6']='6'   ['six']='6'
        ['7']='7'   ['seven']='7'
        ['8']='8'   ['eight']='8'
        ['9']='9'   ['nine']='9'
    )

    while read -r line; do
        nums="${line//[[:alpha:]]/}"
        nums="${nums:0:1}${nums: -1}"
        (( sums[0] += nums ))

        [[ "${line,,}" =~ $rgx ]];      first="${BASH_REMATCH[1]}"
        [[ "${line,,}" =~ ^.*$rgx ]];   last="${BASH_REMATCH[1]}"
        nums="${lookup[$first]}${lookup[$last]}"
        (( sums[1] += nums ))
    done < "${1}"

    printf '%d\n' "${sums[@]}"
}
