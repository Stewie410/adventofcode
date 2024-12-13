#!/usr/bin/env bash

# depth stones...
blinkx() {
    local -a stones queue
    local i j len depth
    depth="${1}"
    shift

    while (( $# > 0 )); do
        (( stones[${1}]++ ))
        shift
    done

    for (( i = 0; i < depth; i++ )); do
        queue=()
        for j in "${!stones[@]}"; do
            if (( j == 0 )); then
                (( queue[1] += stones[j] ))
            elif (( ${#j} % 2 == 0 )); then
                (( len = ${#j} / 2 ))
                (( queue[${j:0:len}] += stones[j] ))
                (( queue[10#${j:len}] += stones[j] ))
            else
                (( queue[j * 2024] += stones[j] ))
            fi
        done
        stones=()
        for j in "${!queue[@]}"; do
            (( stones[j] = queue[j] ))
        done
    done

    unset len
    for i in "${!stones[@]}"; do
        (( len += stones[i] ))
    done

    printf '%s\n' "${len:-0}"
}

main() {
    local -a initial

    read -ra initial < "${1:-/dev/stdin}"
    blinkx "25" "${initial[@]}"
    blinkx "75" "${initial[@]}"
}

main "${@}"
