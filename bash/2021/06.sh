#!/usr/bin/env bash

shift_array() {
    shift
    printf '%s\n' "${@}"
}

model() {
    local -a fish counts
    local j k

    mapfile -t fish < <(tr "," '\n' < "${1}")
    for j in {0..8}; do
        counts[$j]="0"
    done

    for j in "${fish[@]}"; do
        (( counts[j]++ ))
    done

    for (( j = 0; j < $2; j++ )); do
        k="${counts[0]}"
        mapfile -t counts < <(shift_array "${counts[@]}")
        (( counts[6] += k ))
        counts[8]="${k}"
    done

    tr " " '+' <<< "${counts[@]}" | bc
}

main() {
    set -- "${1:-/dev/null}"
    model "${1}" "80"
    model "${1}" "256"
}

main "${@}"
