#!/usr/bin/env bash

gcd() {
    if ! (( ${1} % ${2} )); then
        printf '%d\n' "${2}"
        return
    fi
    gcd "${2}" "$(( ${1} % ${2} ))"
}

lcm() {
    local g l
    l="${1}"
    shift
    while (( $# > 0 )); do
        g="$(gcd "${l}" "${1}")"
        (( l = (l * ${1}) / g ))
        shift
    done
    printf '%d\n' "${l}"
}

solution() {
    local -A graph
    local -a starts cycles
    local j line pos moves steps

    while read -r line; do
        if [[ "${line}" =~ ^[LR]+$ ]]; then
            moves="${line}"
        elif [[ "${line}" == *"="* ]]; then
            read -r j line <<< "${line//[^[:alnum:][:blank:]]/}"
            graph["${j}"]="${line}"
            [[ "${j:2}" == "A" ]] && starts+=("${j}")
        fi
    done < "${1}"

    for (( j = 0; j < ${#moves}; j = j + 1 == ${#moves} ? 0 : j + 1 )); do
        (( steps++ ))
        case "${moves:j:1}" in
            L ) pos="${graph["${pos:-AAA}"]% *}";;
            R ) pos="${graph["${pos:-AAA}"]##* }";;
        esac
        [[ "${pos}" == "ZZZ" ]] && break
    done
    printf '%d\n' "${steps}"

    for pos in "${starts[@]}"; do
        unset steps
        for (( j = 0; j < ${#moves}; j = j + 1 == ${#moves} ? 0 : j + 1 )); do
            (( steps++ ))
            case "${moves:j:1}" in
                L ) pos="${graph["$pos"]% *}";;
                R ) pos="${graph["$pos"]##* }";;
            esac
            [[ "${pos:2}" != "Z" ]] && continue
            cycles+=("${steps}")
            break
        done
    done
    lcm "${cycles[@]}"
}
