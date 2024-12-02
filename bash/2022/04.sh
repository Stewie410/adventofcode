#!/usr/bin/env bash
#
# 2022-12-04

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
