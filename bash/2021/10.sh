#!/usr/bin/env bash

get_closing_char() {
    local -A list
    list=( ['[']=']' ['(']=')' ['{']='}' ['<']='>' )
    printf '%s\n' "${list["$1"]}"
}

part_a() {
    _get_score() {
        local -A _scores
        local -a stack
        local char

        _scores=( [')']="3" [']']="57" ['}']="1197" ['>']="25137" )

        while read -r char; do
            if [[ "${char}" =~ [\[\{\(\<] ]]; then
                stack+=("${char}")
            elif [[ "${char}" != "$(get_closing_char "${stack[-1]}")" ]]; then
                printf '%s\n' "${_scores["$char"]}"
                return
            else
                unset 'stack[-1]'
            fi
        done < <(fold --width="1" <<< "${1}")

        printf '0\n'
    }

    local line sum
    sum="0"

    while read -r line; do
        (( sum += $(_get_score "${line}") ))
    done < "${1}"

    printf '%s\n' "${sum}"
}

part_b() {
    _get_score() {
        local -A _scores
        local -a stack
        local char result closing

        _scores=( [')']="1" [']']="2" ['}']="3" ['>']="4" )

        while read -r char; do
            if [[ "${char}" =~ [\[\{\(\<] ]]; then
                stack+=("${char}")
            elif [[ "${char}" == "$(get_closing_char "${stack[-1]}")" ]]; then
                unset 'stack[-1]'
            else
                printf '0\n'
                return 1
            fi
        done < <(fold --width="1" <<< "${1}")

        mapfile -t stack < <(rev <<< "${stack[@]}" | tr " " '\n')
        result="0"

        for char in "${stack[@]}"; do
            closing="$(get_closing_char "${char}")"
            result="$(( (result * 5) + ${_scores["$closing"]} ))"
        done

        printf '%s\n' "${result}"
    }

    local -a scores
    local line

    while read -r line; do
        scores+=("$(_get_score "${line}")")
        (( scores[-1] == 0 )) && unset 'scores[-1]'
    done < "${1}"

    mapfile -t scores < <(printf '%s\n' "${scores[@]}" | sort --numeric-sort)

    printf '%s\n' "${scores[$(( ${#scores[@]} / 2 ))]}"
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
