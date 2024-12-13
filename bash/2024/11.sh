#!/usr/bin/env bash

# ref(out) stone count
blink() {
    local -n out="${1}"
    local stone count len
    (( stone = ${2}, count = ${3} - 1 ))

    if (( count < 0 )); then
        (( out++ ))
    elif (( stone == 0 )); then
        blink "${1}" "1" "${count}"
    elif (( ${#stone} % 2 == 0 )); then
        (( len = ${#stone} / 2 ))
        blink "${1}" "${stone:0:len}" "${count}"
        blink "${1}" "$(( 10#${stone:len} ))" "${count}"
    else
        blink "${1}" "$(( 2024 * stone ))" "${count}"
    fi
}

# depth stones...
iterative() {
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
    iterative "25" "${initial[@]}"
    iterative "75" "${initial[@]}"
}

main "${@}"
