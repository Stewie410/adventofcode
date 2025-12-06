#!/usr/bin/env bash

merge() {
    local -a arr
    arr=( "${@}" )

    local i j a b c d
    for (( i = 0; i < ${#arr[@]}; i++ )); do
        a="${arr[i]%-*}"
        b="${arr[i]#*-}"
        for (( j = 0; j < "${#arr[@]}"; j++ )); do
            (( i == j )) && continue
            c="${arr[j]%-*}"
            d="${arr[j]#*-}"

            if (( (a >= c && a <= d) || (b >= c && b <= d) )); then
                (( a = a < c ? a : c ))
                (( b = b > d ? b : d ))
                arr["$j"]="${a}-${b}"
                unset "arr[$i]"
                arr=( "${arr[@]}" )
                (( i-- ))
                break
            fi
        done
    done

    printf '%s\n' "${arr[@]}"
}

main() {
    local -a ranges
    local line r p1
    while read -r line; do
        (( ${#line} == 0 )) && continue
        if [[ "${line}" == *"-"* ]]; then
            ranges+=( "${line}" )
        else
            for r in "${ranges[@]}"; do
                if (( line >= ${r%-*} && line <= ${r#*-} )); then
                    (( p1++ ))
                    break
                fi
            done
        fi
    done < "${1:-/dev/stdin}"

    local p2
    mapfile -t ranges < <(merge "${ranges[@]}")
    for r in "${ranges[@]}"; do
        (( p2 += ${r#*-} - ${r%-*} + 1 ))
    done

    printf '%d\n' "${p1:-0}" "${p2:-0}"
}

main "${@}"
