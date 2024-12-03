#!/usr/bin/env bash

part_a() {
    local inc

    while (( $# > 1 )); do
        (( inc += $2 > $1 ))
        shift
    done

    printf '%s\n' "${inc:-0}"
}

part_b() {
    local inc

    while (( $# > 3 )); do
        (( inc += ($2 + $3 + $4) > ($1 + $2 + $3) ))
        shift
    done

    printf '%s\n' "${inc:-0}"
}

main() {
    local -a data
    mapfile -t data < "${1:-/dev/stdin}"
    part_a "${data[@]}"
    part_b "${data[@]}"
}

main "${@}"
