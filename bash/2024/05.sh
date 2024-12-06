#!/usr/bin/env bash

# 2d+ arrays are so pain
# TODO: lookup table, somehow?
main() {
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
