#!/usr/bin/env bash
#
# 2022-12-09

part_a() {
    local -A steps
    local -a head tail
    local direction distance xdiff ydiff

    head=(0 0)
    tail=(0 0)
    steps['0,0']="1"

    while read -r direction distance; do
        case "${direction^^}" in
            U )     (( head[1] -= distance ));;
            D )     (( head[1] += distance ));;
            L )     (( head[0] -= distance ));;
            R )     (( head[0] += distance ));;
        esac

        xdiff="$(( head[0] - tail[0] ))"
        ydiff="$(( head[1] - tail[1] ))"

        while (( ${xdiff/-/} > 1 || ${ydiff/-/} > 1 )); do
            (( tail[0] += head[0] < tail[0] ? -1 : head[0] > tail[0] ? 1 : 0 ))
            (( tail[1] += head[1] < tail[0] ? -1 : head[1] > tail[1] ? 1 : 0 ))
            steps["${tail[0]},${tail[1]}"]="1"
            xdiff="$(( head[0] - tail[0] ))"
            ydiff="$(( head[1] - tail[1] ))"
        done
    done < "${1}"

    printf '%s\n' "${#steps[@]}"
}

part_b() {
    local -A steps
    local -a kx ky
    local direction distance xdiff ydiff j k

    kx=(0 0 0 0 0 0 0 0 0 0)
    ky=(0 0 0 0 0 0 0 0 0 0)
    steps=['0,0']="1"

    while read -r direction distance; do
        for (( j = 1; j <= distance; j++ )); do
            case "${direction^^}" in
                U )     (( ky[0]-- ));;
                D )     (( ky[0]++ ));;
                L )     (( kx[0]-- ));;
                R )     (( kx[0]++ ));;
            esac

            for (( k = 1; k < 10; k++ )); do
                xdiff="$(( kx[k - 1] - kx[k] ))"
                ydiff="$(( ky[k - 1] - ky[k] ))"

                while (( ${xdiff/-/} > 1 || ${ydiff/-/} > 1 )); do
                    (( kx[k] += kx[k - 1] < kx[k] ? -1 : kx[k - 1] > kx[j] ? 1 : 0 ))
                    (( ky[k] += ky[k - 1] < ky[k] ? -1 : ky[k - 1] > ky[k] ? 1 : 0 ))
                    steps["${kx[9]},${ky[9]}"]="1"
                    xdiff="$(( kx[k - 1] - kx[k] ))"
                    ydiff="$(( ky[k - 1] - ky[k] ))"
                done
            done
        done
    done < "${1}"

    printf '%s\n' "${#steps[@]}"
}
