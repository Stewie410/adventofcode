#!/usr/bin/env bash

part_a() {
    local a b c str score
    str="1231"

    while read -r a b; do
        (( score += b ))

        c="${str#*${a}${b}}"

        if (( ${#str} != ${#c} )); then
            (( score += 6 ))
        elif (( a == b )); then
            (( score += 3 ))
        fi
    done < <(tr 'XYZ' 'ABC' < "${1}" | tr 'ABC' '123')

    printf '%s\n' "${score}"
}

part_b() {
    local a b c str score
    str="1231"

    while read -r a b; do
        case "${b}" in
            X )     b="$(( a - 1 ))"; (( b == 0 )) && b="3";;
            Y )     b="${a}";;
            Z )     b="$(( a + 1 ))"; (( b == 4 )) && b="1";;
        esac

        (( score += b ))

        c="${str#*${a}${b}}"

        if (( ${#str} != ${#c} )); then
            (( score += 6 ))
        elif (( a == b )); then
            (( score += 3 ))
        fi
    done < <(tr 'ABC' '123' < "${1}")

    printf '%s\n' "${score}"
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
