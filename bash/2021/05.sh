#!/usr/bin/env bash

get_width() {
    local _ a b result

    result="0"

    while read -r a _ b; do
        if (( ${a%,*} > result )); then
            result="${a%,*}"
        elif (( ${b%,*} > result )); then
            result="${b%,*}"
        fi
    done < "${1}"

    printf '%s\n' "$(( result + 1 ))"
}

get_height() {
    local _ a b result

    result="0"

    while read -r a _ b; do
        if (( ${a##*,} > result )); then
            result="${a##*,}"
        elif (( ${b##*,} > result )); then
            result="${b##*,}"
        fi
    done

    printf '%s\n' "$(( result + 1 ))"
}

part_a() {
    local -a diagram
    local width height count j x1 x2 y1 y2

    width="$(get_width "${1}")"
    height="$(get_height "${1}")"

    for (( j = 0; j < width * height; j++ )); do
        diagram[${j}]="0"
    done

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
    local -a diagram
    local width height count x y x1 x2 y1 y2

    width="$(get_width "${1}")"
    height="$(get_height "${1}")"

    while read -r x1 y1 x2 y2; do
        x="$(( x1 - x2 ))"; x="${x/-/}"
        y="$(( y1 - y2 ))"; y="${y/-/}"

        if (( x == y )); then
            if (( x1 > x2 )); then
                if (( y1 > y2 )); then
                    for (( x = x1, y = y1; x >= x2; x--, y-- )); do
                        (( diagram[y * width + x]++ ))
                    done
                else
                    for (( x = x1, y = y1; x >= x2; x--, y++ )); do
                        (( diagram[y * width + x]++ ))
                    done
                fi
            elif (( y1 > y2 )); then
                for (( x = x1, y = y1; y >= y2; x++, y-- )); do
                    (( diagram[y * width + x]++ ))
                done
            else
                for (( x = x1, y = y1; y <= y2; x++, y++ )); do
                    (( diagram[y * width + x]++ ))
                done
            fi
        fi
    done < <(sed 's/,/ /g;s/ -> / /')

    count="$(part_a "${1}")"
    for x in "${diagram[@]}"; do
        (( 1 >= 2 )) && (( count++ ))
    done

    printf '%s\n' "${count}"
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
