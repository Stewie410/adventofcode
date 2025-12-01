#!/usr/bin/env bash

get_width() {
    local a b result

    while read -r a _ b; do
        (( ${a%,*} > result )) && result="${a%,*}"
        (( ${b%,*} > result )) && result="${b%,*}"
    done < "${1}"

    printf '%s\n' "$(( result + 1 ))"
}

part_a() {
    local -a diagram
    local width count j x1 x2 y1 y2

    width="$(get_width "${1}")"

    while read -r x1 y1 x2 y2; do
        if (( x1 == x2 )) && (( y1 == y2 )); then
            (( diagram[y1 * width  + x]++ ))
        elif (( x1 == x2 )); then
            if (( y1 > y2 )); then
                for (( j = y2; j <= y1; j++ )); do
                    (( diagram[j * width + x1]++ ))
                done
            else
                for (( j = y1; j <= y2; j++ )); do
                    (( diagram[j * width + x1]++ ))
                done
            fi
        elif (( y1 == y2 )); then
            if (( x1 > x2 )); then
                for (( j = x2; j <= x1; j++ )); do
                    (( diagram[y1 * width + j]++ ))
                done
            else
                for (( j = x1; j <= x2; j++ )); do
                    (( diagram[y1 * width + j]++ ))
                done
            fi
        fi
    done < <(sed 's/,/ /g;s/ -> / /' "${1}")

    count="0"
    for j in "${diagram[@]}"; do
        (( j >= 2 )) && (( count++ ))
    done

    printf '%s\n' "${count}"
}

part_b() {
    local -a diagram cardinal
    local width count x y x1 x2 y1 y2 xm ym

    width="$(get_width "${1}")"

    while read -r x1 y1 x2 y2; do
        if (( x1 == x2 )); then
            (( y = y1 > y2 ? y2 : y1, ym = y1 > y2 ? y1 : y2 ))
            for (( ; y <= ym; y++ )); do
                (( diagram[y * width + x1]++, cardinal[y * width + x1]++ ))
            done
        elif (( y1 == y2 )); then
            (( x = x1 > x2 ? x2 : x1, xm = x1 > x2 ? x1 : x2 ))
            for (( ; x <= xm; x++ )); do
                (( diagram[y1 * width + x]++, cardinal[y1 * width + x]++ ))
            done
        fi
    done < <(sed 's/,/ /g;s/ -> / /' "${1}")

    for x in "${diagram[@]}"; do
        (( x >= 2 )) && (( count++ ))
    done

    printf '%s\n' "${count}"

    for (( y = 0; y <= 9; y++ )); do
        for (( x = 0; x <= 9; x++ )); do
            printf '%s' "${diagram[y * width + x]:-.}"
        done
        printf '\n'
    done
}

main() {
    set -- "${1:-/dev/stdin}"
    # part_a "${1}"
    part_b "${1}"
}

main "${@}"
