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
