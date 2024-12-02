#!/usr/bin/env bash

part_a() {
    local a b c d total

    while read -r a b c d; do
        if (( a <= c && b >= d )) || (( a >= c && b <= d )); then
            (( total++ ))
        fi
    done < <(tr ",-" ' ' < "${1}")

    printf '%s\n' "${total}"
}

part_b() {
    local a b c d total

    while read -r a b c d; do
        if (( a <= c && b >= c )) || (( a >= c && a <= d )); then
            (( total++ ))
        fi
    done < <(tr ",-" ' ' < "${1}")

    printf '%s\n' "${total}"
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
