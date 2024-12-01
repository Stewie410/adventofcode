#!/usr/bin/env bash

# adapted from SO answer
# https://stackoverflow.com/a/55615989
bubble() {
    local -n list="${1}"
    local i j

    for (( i = 0; i < ${#list[@]}; i++ )); do
        for (( j = 0; j < ${#list[@]} - i - 1; j++ )); do
            if (( list[j] > list[j+1] )); then
                # Thanks Primeagen for that one short
                # https://en.wikipedia.org/wiki/XOR_swap_algorithm
                (( list[j] = list[j] ^ list[j+1] ))
                (( list[j+1] = list[j+1] ^ list[j] ))
                (( list[j] = list[j] ^ list[j+1] ))
            fi
        done
    done
}

solution() {
    local -a left right counts
    local i l r dist distance similarity

    while read -r l r; do
        left+=("${l}")
        right+=("${r}")
        (( counts[r]++ ))
    done < "${1}"

    bubble left
    bubble right

    for (( i = 0; i < ${#left[@]}; i++ )); do
        dist="$(( left[i] - right[i] ))"
        (( distance += ${dist#-} ))
        dist="${left[i]}"
        (( similarity += dist * counts[dist] ))
    done

    printf '%s\n' "${distance}" "${similarity}"
}
