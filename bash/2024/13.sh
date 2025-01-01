#!/usr/bin/env bash
# Part A: linear equations, apparently
#   I'm not familiar with this math (or don't remember it), so I followed
#   this writeup, which helped wrap my head around it:
#
#       https://advent-of-code.xavd.id/writeups/2024/day/13/

# Part A:
#   Button A: x+94, y+36
#   Button B: x+22, y+67
#   Target: x=8400, y=5400
#
#   Split X & Y ops into 2 equations:
#   Ax + Bx: 94a + 22b = 8400
#   Ay + By: 34a + 67b = 5400
#
#   Mutliply each equation by other's 'B' component
#   By * (Ax + Bx): 67 * (94a + 22b == 8400) -> 6298a + 1474b = 562800
#   Ay * (Ay + By): 22 * (34a + 67b == 5400) -> 748a + 1474b = 118800
#
#   Subtract Equ_y from Equ_x, both sides
#   (6298a + 1474b) - (748a + 1474b) == 5628000 - 118800 -> 5550a = 444000
#
#   Solve for A
#   5550a / 5550a = 444000/5550 -> a = 80
#
#   Solve for B with this value
#   Ax + By == C: (80 * 94) + 22b == 8400 -> 7520 + b22 == 8400 -> 22b = 880 -> b = 40
#
#   Result
#   3a + b == total -> (3 * 80) + 40 == total -> total == 280

# Because bash doesn't support decimal values, we need to improv a little
# num div
int_div() {
    (( ${1} % ${2} == 0 )) || return 1
    printf '%d\n' "$(( ${1} / ${2} ))"
    return 0
}

# button_a button_b prize
part_a() {
    local a b
    local ax ay bx by px py
    local ax_by px_by ay_bx py_bx

    read -r ax ay <<< "${1}"
    read -r bx by <<< "${2}"
    read -r px py <<< "${3}"

    (( ax_by = ax * by, px_by = px * by ))
    (( ay_bx = ay * bx, py_bx = py * bx ))

    a="$(int_div "$(( px_by - py_bx ))" "$(( ax_by - ay_bx ))")"
    b="$(int_div "$(( py - ay * a ))" "${by}")"

    if ! a="$(int_div "$(( px_by - py_bx ))" "$(( ax_by - ay_bx ))")"; then
        printf '0\n'
        return 1
    fi

    if ! b="$(int_div "$(( py - ay * a ))" "${by}" )"; then
        printf '0\n'
        return 1
    fi

    printf '%d\n' "$(( (3 * a) + b ))"
}

# button_a button_b prize
part_b() {
    local x y
    read -r x y <<< "${3}"
    part_a "${1}" "${2}" "$(( x + 10000000000000 )) $(( y + 10000000000000 ))"
}

main() {
    local -a buffer
    local i line p1 p2

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

        # printf '%s\n' "${buffer[@]}" "${i}"
        # part_a "${buffer[@]}" "${i}"
        (( p1 += $(part_a "${buffer[@]}" "${i}") ))
        (( p2 += $(part_b "${buffer[@]}" "${i}") ))
        buffer=()
    done < "${1:-/dev/stdin}"

    printf '%d\n' "${p1:-0}" "${p2:-0}"
}

main "${@}"
