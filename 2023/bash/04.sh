#!/usr/bin/env bash

solution() {
    local -a b_scores counts
    local j k len line winning num a_total b_total score

    j="0"

    while read -r line; do
        winning="${line##*:}"
        winning="${winning%|*}"

        (( score = 0, b_scores[j] = score ))
        for num in ${line##*|}; do
            [[ "${winning/ ${num} /}" == "${winning}" ]] && continue
            (( b_scores[j]++, score = score ? score * 2 : 1 ))
        done

        (( a_total += score, counts[j]++, j++ ))
    done < "${1}"

    for (( len = j, j = 0; j < len; j++ )); do
        for (( k = j + 1; k <= j + b_scores[j]; k++ )); do
            (( counts[k] += counts[j] ))
        done
        (( b_total += counts[j] ))
    done

    printf '%d\n' "${a_total}" "${b_total}"
}
