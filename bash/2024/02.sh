#!/usr/bin/env bash

is_safe() {
    local last trend

    while (( $# > 1 )); do
        (( trend = $2 > $1 ? 1 : $2 < $1 ? -1 : 0 ))
        (( trend != ${last:=${trend}} )) && return 1

        (( trend == 0 )) && return 1
        (( trend == 1 && $2 > $1 + 3 )) && return 1
        (( trend == -1 && $2 < $1 - 3 )) && return 1

        shift
    done

    return 0
}

tolerance() {
    local -a arr
    local i
    arr=( "${@}" )

    for (( i = 0; i < $#; i++ )); do
        is_safe "${arr[@]:0:i}" "${arr[@]:i+1}" && return 0
    done

    return 1
}

main() {
    local -a data
    local count tolerance

    while read -ra data; do
        is_safe "${data[@]}" && (( count++ ))
        tolerance "${data[@]}" && (( tolerance++ ))
    done < "${1:-/dev/stdin}"

    printf '%s\n' "${count}" "${tolerance}"
}

main "${@}"
