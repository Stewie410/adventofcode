#!/usr/bin/env bash
#
# 2012-12-01

part_a() {
    local -a data
    local last j inc

    mapfile -t data < "${1}"
    last="${data[0]}"

    for (( j = 1; j < "${#data[@]}"; j++ )); do
        if (( data[j] > last )); then
            (( inc++ ))
        fi
        last="${data[$j]}"
    done

    printf '%s\n' "${inc:-0}"
}

part_b() {
    local -a data
    local last current j inc

    mapfile -t data < "${1}"
    last="$(( data[0] + data[1] + data[2] ))"

    for (( j = 3; j < ${#data[@]}; j++ )); do
        current="$(( data[j] + data[j - 1] + data[j - 2] ))"
        if (( current > last )); then
            (( inc++ ))
        fi
        last="${current}"
    done

    printf '%s\n' "${inc:-0}"
}
