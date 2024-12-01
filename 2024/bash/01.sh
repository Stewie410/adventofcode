#!/usr/bin/env bash

# https://stackoverflow.com/a/30576368
quicksort() {
    (( $# == 0 )) && return 0

    local -a smaller larger
    local pivot i

    smaller=()
    larger=()
    pivot="${1}"
    shift

    for i in "${@}"; do
        if (( i < pivot )); then
            smaller+=( "${i}" )
        else
            larger+=( "${i}" )
        fi
    done

    mapfile -t smaller < <(quicksort "${smaller[@]}")
    mapfile -t larger < <(quicksort "${larger[@]}")
    printf '%s\n' "${smaller[@]}" "${pivot}" "${larger[@]}"
}

# https://www.java67.com/2014/09/insertion-sort-in-java-with-example.html
insertion() {
    local -a arr
    local i j n

    arr=( "${@}" )

    for (( i = 1; i < $#; i++ )); do
        j="${i}"
        while (( j > 0 )) && (( arr[j] < arr[j-1] )); do
            n="${arr[j]}"
            (( arr[j] = arr[j-1], arr[j-1] = n ))
            (( j-- ))
        done
    done

    printf '%s\n' "${arr[@]}"
}

# https://stackoverflow.com/a/55615989
bubble() {
    local -a arr
    local i j n flag
    arr=( "${@}" )

    for (( i = 0; i < $#; i++ )); do
        unset flag
        for (( j = 0; j < $# - i - 1; j++ )); do
            (( arr[j] > arr[j+1] )) || continue
            (( n = arr[j], arr[j] = arr[j+1], arr[j+1] = n ))
            flag="1"
        done
        [[ -z "${flag}" ]] && break
    done

    printf '%s\n' "${arr[@]}"
}

solution() {
    local -a left right counts
    local i l r dist distance similarity

    while read -r l r; do
        left+=("${l}")
        right+=("${r}")
        (( counts[r]++ ))
    done < "${1}"

    # mapfile -t left < <(bubble "${left[@]}")
    # mapfile -t right < <(bubble "${right[@]}")

    # mapfile -t left < <(insertion "${left[@]}")
    # mapfile -t right < <(insertion "${right[@]}")

    mapfile -t left < <(quicksort "${left[@]}")
    mapfile -t right < <(quicksort "${right[@]}")

    for (( i = 0; i < ${#left[@]}; i++ )); do
        dist="$(( left[i] - right[i] ))"
        (( distance += ${dist#-} ))
        dist="${left[i]}"
        (( similarity += dist * counts[dist] ))
    done

    printf '%s\n' "${distance}" "${similarity}"
}
