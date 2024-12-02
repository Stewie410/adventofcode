#!/usr/bin/env bash

# See how much easier our lives would be if we could just use coreutils?
cheating() {
    printf '%s\n' "${@}" | sort --numeric-sort
}

# https://stackoverflow.com/a/30576368
# iterative quicksort
quicksort_iter() {
    (( $# == 0 )) && return 0

    local -a stack arr smaller larger
    local start stop pivot i

    stack=( "0" "$(( $# - 1 ))" )
    arr=( "${@}" )

    while (( ${#stack[@]} > 0 )); do
        (( start = stack[0], stop = stack[1] ))
        stack=( "${stack[@]:2}" )
        smaller=()
        larger=()
        pivot="${arr[start]}"

        for (( i = start + 1; i <= stop; i++ )); do
            if (( arr[i] < pivot )); then
                smaller+=( "${arr[i]}" )
            else
                larger+=( "${arr[i]}" )
            fi
        done

        arr=(
            "${arr[@]:0:start}"
            "${smaller[@]}"
            "${pivot}"
            "${larger[@]}"
            "${arr[@]:stop+1}"
        )

        if (( ${#smaller[@]} >= 2 )); then
            stack+=( "${start}" "$(( start + ${#smaller[@]} - 1 ))")
        fi
        if (( ${#larger[@]} >= 2 )); then
            stack+=( "$(( stop - ${#larger[@]} + 1 ))" "${stop}" )
        fi
    done

    printf '%s\n' "${arr[@]}"
}

# https://stackoverflow.com/a/30576368
# recursive quicksort
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
    local i l r n distance similarity

    while read -r l r; do
        left+=("${l}")
        right+=("${r}")
        (( counts[r]++ ))
    done < "${1}"

    # mapfile -t left < <(cheating "${left[@]}")
    # mapfile -t right < <(cheating "${right[@]}")

    # mapfile -t left < <(bubble "${left[@]}")
    # mapfile -t right < <(bubble "${right[@]}")

    # mapfile -t left < <(insertion "${left[@]}")
    # mapfile -t right < <(insertion "${right[@]}")

    # mapfile -t left < <(quicksort "${left[@]}")
    # mapfile -t right < <(quicksort "${right[@]}")

    mapfile -t left < <(quicksort_iter "${left[@]}")
    mapfile -t right < <(quicksort_iter "${right[@]}")

    for (( i = 0; i < ${#left[@]}; i++ )); do
        (( n = left[i] - right[i] ))
        (( distance += n * ((n > 0) - ( n < 0)) ))
        (( similarity += left[i] * counts[(left[i])] ))
    done

    printf '%s\n' "${distance}" "${similarity}"
}

main() {
    set -- "${1:-/dev/stdin}"
    solution "${1}"
}

main "${@}"
