#!/usr/bin/env bash

get_types() {
    _sort() {
        printf '%s\n' "${@}" | sort --numeric-sort --reverse
    }

    _value() {
        local v
        case "${1}" in
            5 ) v="7";;
            4 ) v="6";;
            3 ) (( v = ${2} == 2 ? 5 : 4 ));;
            2 ) (( v = ${2} == 2 ? 3 : 2 ));;
            1 ) v="1";;
        esac
        printf '%d\n' "${v:-0}"
    }

    local -a a_counts b_counts
    local c v jokers

    jokers="${1//[^B]/}"
    jokers="${#jokers}"

    for c in {2..9} {A..E}; do
        v="${1//[^${c}]/}"
        a_counts+=("${#v}")
        [[ "${c}" != "B" ]] && b_counts+=("${#v}")
    done

    mapfile -t a_counts < <(_sort "${a_counts[@]}")
    mapfile -t b_counts < <(_sort "${b_counts[@]}")
    (( b_counts[0] += jokers ))

    _value "${a_counts[@]}"
    _value "${b_counts[@]}"
}

solution() {
    local -a a_hands b_hands values results
    local j hand bid

    while read -r hand bid; do
        mapfile -t values < <(get_types "${hand}")
        a_hands+=("${values[0]} ${hand} ${bid}")
        b_hands+=("${values[1]} ${hand} ${bid}")
    done < <(tr 'TJQKA' 'ABCDE' < "${1}")

    mapfile -t a_hands < <(printf '%s\n' "${a_hands[@]}" | sort)
    mapfile -t b_hands < <(printf '%s\n' "${b_hands[@]//B/1}" | sort)

    for (( j = 0; j < ${#a_hands[@]}; j++ )); do
        (( results[0] += (j + 1) * ${a_hands[j]##* } ))
        (( results[1] += (j + 1) * ${b_hands[j]##* } ))
    done

    printf '%d\n' "${results[@]}"
}
