#!/usr/bin/env bash

# val ref
index_of() {
    local -n arr="${2}"
    local i
    for (( i = 0; i < ${#arr[@]}; i++ )); do
        (( arr[i] == ${1} )) || continue
        printf '%s\n' "${i}"
        return 0
    done
    return 1
}

# Works on test, but not on 'real' data
# rule ...
get_lookup() {
    local -a list
    local a b i ai bi rule flag

    while read -r a b; do
        (( list[a]++, list[b]++ ))
    done < <(printf '%s\n' "${@/|/ }")
    list=( "${!list[@]}" )

    while [[ -z "${flag}" ]]; do
        printf '%s\n' "${list[*]}"
        flag="1"
        while read -r a b; do
            for (( i = 0, ai = -1, bi = -1; ai < 0 || bi < 0; i++ )); do
                (( a == list[i] )) && ai="${i}"
                (( b == list[i] )) && bi="${i}"
            done

            if (( ai > bi )); then
                unset flag
                list[ai]="${b}"
                list[bi]="${a}"
            fi
        done < <(printf '%s\n' "${@/|/ }")
    done

    # printf '%s\n' "${list[@]}"
    printf '%s\n' "${list[*]}"
}

try_lookup() {
    local -a rules lines lookup pages copy
    local line i valid sum1 sum2

    while read -r line; do
        case "${line:2:1}" in
            "|" )   rules+=( "${line}" );;
            "," )   lines+=( "${line}" );;
        esac
    done < "${1}"

    get_lookup "${rules[@]}"
    return

    mapfile -t lookup < <(get_lookup "${rules[@]}")

    for line in "${lines[@]}"; do
        IFS=',' read -ra pages <<< "${line}"

        # build sorted copy
        copy=()
        for (( i = 0; i < ${#lookup[@]}; i++ )); do
            index_of "${lookup[i]}" "pages" &>/dev/null || continue
            copy+=( "${lookup[i]}" )
        done
        # printf '%s -> %s\n' "${pages[*]}" "${copy[*]}"
        # continue

        valid="1"
        for (( i = 0; i < ${#pages[@]}; i++ )); do
            (( pages[i] == copy[i] )) && continue
            unset valid
            break
        done

        if [[ -n "${valid}" ]]; then
            printf 'Part A: %s\n' "${pages[*]}" >&2
            (( sum1 += pages[${#pages[@]} / 2] ))
        else
            printf 'Part B: %s\n' "${pages[*]}" >&2
            (( sum2 += copy[${#copy[@]} / 2] ))
        fi
    done

    printf '%s\n' "${sum1:-0}" "${sum2:-0}"
}

main() {
    set -- "${1:-/dev/stdin}"
    try_lookup "${1}"
    # solution "${1}"
}

# 2d+ arrays are so pain
# TODO: lookup table, somehow?
solution() {
    local -a rules lines pages rule
    local i line pass fail num1 num2 p1 p2

    while read -r line; do
        if [[ "${line}" == *"|"* ]]; then
            rules+=( "${line/|/ }" )
        elif [[ "${line}" == *","* ]]; then
            lines+=( "${line//,/ }" )
        fi
    done < "${1:-/dev/stdin}"

    # 'while read -ra' doesn't really work here, since var can't be modified
    # in the loop -- so we have this 'for; read' mess.
    for line in "${lines[@]}"; do
        read -ra pages <<< "${line}"
        pass="1"
        while true; do
            unset fail
            while read -ra rule; do
                # who needs indexOf() anyway?
                unset num1 num2
                for (( i = 0; i < ${#pages[@]}; i++ )); do
                    (( pages[i] == rule[0] )) && num1="${i}"
                    (( pages[i] == rule[1] )) && num2="${i}"
                done
                [[ -n "${num1}" && -n "${num2}" ]] || continue

                if (( num1 > num2 )); then
                    fail="1"
                    pages[num1]="${rule[1]}"
                    pages[num2]="${rule[0]}"
                    break
                fi
            done < <(printf '%s\n' "${rules[@]}")

            if [[ -n "${fail}" ]]; then
                unset pass
                continue
            else
                break
            fi
        done

        if [[ -n "${pass}" ]]; then
            printf 'Part A: %s\n' "${pages[*]}" >&2
            (( p1 += pages[${#pages[@]} / 2] ))
        else
            printf 'Part B: %s\n' "${pages[*]}" >&2
            (( p2 += pages[${#pages[@]} / 2 ] ))
        fi
    done

    printf '%s\n' "${p1}" "${p2}"
}

main "${@}"
