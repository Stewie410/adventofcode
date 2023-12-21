#!/usr/bin/env bash
#
# 2021-12-06

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

part_a() {
    model "${1}" "80"
}

part_b() {
    model "${1}" "256"
}
