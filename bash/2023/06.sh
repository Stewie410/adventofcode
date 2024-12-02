#!/usr/bin/env bash
# shellcheck disable=SC2154
#
# This is the worst thing I've every written.
#
# Thankfully, the final version was cowritten by a friend (@Grub4K), who would
# not take "no" for an answer.

solution() {
    local j line result square sqrt quad

    while read -r line; do
        local -a "${line/:/=(} ${line//[^[:digit:]]/})"
    done < "${1}"

    for (( result = 1, j = 0; j < ${#Time[@]}; j++ )); do
        square="$(( Time[j] ** 2 - 4 * Distance[j] - 1 ))"
        sqrt="$(( square / (11 << 10) + 42 ))"
        for _ in {1..20}; do
            (( sqrt = (square / sqrt + sqrt) >> 1 ))
        done
        (( quad = sqrt + ((sqrt ^ Time[j] ^ 1) & 1), result *= quad ))
    done

    printf '%d\n' "$(( result / quad ))" "${quad}"
}

main() {
    set -- "${1:-/dev/stdin}"
    solution "${1}"
}

main "${@}"
