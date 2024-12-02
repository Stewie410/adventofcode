#!/usr/bin/env bash

part_a() {
    local -a crab
    local j k ceiling least position distance cost

    ceiling="0"

    while read -r j k; do
        crab[$k]="${j}"
        (( k > ceiling )) && ceiling="${k}"
    done < <(tr "," '\n' < "${1}" | \
        sort --numeric-sort | \
        uniq --count | \
        sed 's/^\s*//' \
    )

    for (( j = 0; j <= ceiling; j++ )); do
        cost="0"

        for k in "${!crab[@]}"; do
            distance="$(( k - j ))"
            (( cost += ${distance/-/} * crab[k] ))
        done

        if [[ -z "${least}" ]] || (( cost < least )); then
            least="${cost}"
            position="${j}"
        fi
    done

    printf '%s (%s)\n' "${least}" "${position}"
}

part_b() {
    local -a crab
    local j k ceiling least position distance cost

    ceiling="0"

    while read -r j k; do
        crab[$k]="${j}"
        (( k > ceiling )) && ceiling="${k}"
    done < <(tr "," '\n' < "${1}" | \
        sort --numeric-sort | \
        uniq --count | \
        sed 's/^\s*//' \
    )

    for (( j = 0; j <= ceiling; j++ )); do
        cost="0"

        for k in "${!crab[@]}"; do
            distance="$(( k - j ))"
            distance="${distance/-/}"
            (( cost += ( (distance ** 2 + distance) / 2) * crab[k] ))
        done

        if [[ -z "${least}" ]] || (( cost < least )); then
            least="${cost}"
            position="${j}"
        fi
    done

    printf '%s (%s)\n' "${least}" "${position}"
}

main() {
    set -- "${1:-/dev/null}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
