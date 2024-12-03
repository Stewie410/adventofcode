#!/usr/bin/env bash

part_a() {
    local -a lines count
    local i j gamma epsilon

    mapfile -t lines < "${1}"

    for (( i = 0; i < ${#lines[0]}; i++ )); do
        (( count[0] = 0, count[1] = 0 ))
        for (( j = 0; j < ${#lines[@]}; j++ )); do
            (( count[${lines[j]:i:1}]++ ))
        done
        gamma+="$(( count[0] > count[1] ? 0 : 1 ))"
        epsilon+="$(( !${gamma: -1} ))"
    done

    printf '%s\n' "$(( (2#${gamma}) * (2#${epsilon}) ))"
}

part_b() {
    local -a lines count oxy co copy
    local i j bit

    mapfile -t oxy < "${1}"
    mapfile -t co < "${1}"

    while (( ${#oxy[@]} > 1 )); do
        for (( i = 0; i < ${#oxy[0]}; i++ )); do
            (( ${#oxy[@]} == 1 )) && break 2
            (( count[0] = 0, count[1] = 0 ))
            for (( j = 0; j < ${#oxy[@]}; j++ )); do
                (( count[${oxy[j]:i:1}]++ ))
            done
            bit="$(( count[0] > count[1] ? 0 : 1 ))"
            copy=()
            for (( j = 0; j < ${#oxy[@]}; j++ )); do
                (( ${oxy[j]:i:1} != bit )) && continue
                copy+=( "${oxy[j]}" )
            done
            oxy=( "${copy[@]}" )
        done
    done

    while (( ${#co[@]} > 1 )); do
        for (( i = 0; i < ${#co[0]}; i++ )); do
            (( ${#co[@]} == 1 )) && break 2
            (( count[0] = 0, count[1] = 0 ))
            for (( j = 0; j < ${#co[@]}; j++ )); do
                (( count[${co[j]:i:1}]++ ))
            done
            bit="$(( count[1] < count[0] ? 1 : 0 ))"
            copy=()
            for (( j = 0; j < ${#co[@]}; j++ )); do
                (( ${co[j]:i:1} != bit )) && continue
                copy+=( "${co[j]}" )
            done
            co=( "${copy[@]}" )
        done
    done

    printf '%s\n' "$(( (2#${oxy[0]}) * (2#${co[0]}) ))"
}


main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
