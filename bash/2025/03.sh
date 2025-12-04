#!/usr/bin/env bash

# bank, len
max() {
    local -a cell
    local i

    for (( i = 0; i < ${#1}; i++ )); do
        cell+=( "${1:i:1}" )
    done

    local j start max num remain
    start="0"
    for (( i = 0; i < ${2}; i++ )); do
        max="${start}"
        (( remain = ${2} - i - 1 ))
        for (( j = start; j < (${#1} - remain); j++ )); do
            (( cell[j] > cell[max] )) && (( max = j ))
        done
        num+="${cell[max]}"
        (( start = max + 1 ))
    done

    printf '%d\n' "${num:-0}"
}

p1_bf() {
    local -a map
    local line i j jolt max total

    while read -r line; do
        map=( "${line:0:1}" )
        for (( i = 1; i < ${#line}; i++ )); do
            (( map[-1] == ${line:i:1} )) && continue
            map+=( "${line:i:1}" )
        done

        for (( i = 0, max = 0; i < (${#map[@]} - 1); i++ )); do
            for (( j = i + 1; j < ${#map[@]}; j++ )); do
                jolt="${map[i]}${map[j]}"
                (( jolt > max )) && max="${jolt}"
            done
        done
        (( total += max ))
    done < "${1}"

    printf '%d\n' "${total:-0}"
}

main() {
    local line p1 p2 max1 max2
    while read -r line; do
        max1="$(max "${line}" 2)"
        max2="$(max "${line}" 12)"
        (( p1 += max1, p2 += max2 ))
    done < "${1:-/dev/stdin}"

    printf '%d\n' "${p1:-0}" "${p2:-0}"
}

main "${@}"
