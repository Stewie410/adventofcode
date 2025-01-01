#!/usr/bin/env bash
# Puzzle: linear equations, apparently
#   I'm not familiar with this math (or don't remember it), so I followed
#   this writeup, which helped wrap my head around it:
#
#       https://advent-of-code.xavd.id/writeups/2024/day/13/

# Because bash doesn't support decimal values, we need to improv a little
# num div
int_div() {
    (( ${1} % ${2} == 0 )) || return 1
    printf '%d\n' "$(( ${1} / ${2} ))"
    return 0
}

# steps(a) steps(b) prize
get_costs() {
    local -a costs
    local i x y a b ax ay bx by px py
    local ax_by ay_bx px_by py_bx

    read -r ax ay <<< "${1}"
    read -r bx by <<< "${2}"
    read -r x y <<< "${3}"

    (( ax_by = ax * by, ay_bx = ay * bx ))

    for i in "0" "10000000000000"; do
        (( costs[i] = 0, px = x + i, py = y + i ))
        (( px_by = px * by, py_bx = py * bx ))

        a="$(int_div "$(( px_by - py_bx ))" "$(( ax_by - ay_bx ))")" || continue
        b="$(int_div "$(( py - ay * a ))" "${by}")" || continue

        (( costs[i] = 3 * a + b ))
    done

    printf '%s\n' "${costs[*]}"
}

main() {
    local -a buffer
    local i line p1 p2 total1 total2

    while read -r line; do
        # empty lines, ugh
        [[ "${line}" != *":"* ]] && continue

        # simplify instructions
        i="${line##*: }"
        i="${i//[XY+=]/}"
        i="${i//,/}"

        # buffer?
        if [[ "${line}" != "Prize:"* ]]; then
            buffer+=( "${i}" )
            continue
        fi

        read -r p1 p2 < <(get_costs "${buffer[@]}" "${i}")
        (( total1 += p1, total2 += p2 ))
        buffer=()
    done < "${1:-/dev/stdin}"

    printf '%d\n' "${total1:-0}" "${total2:-0}"
}

main "${@}"
