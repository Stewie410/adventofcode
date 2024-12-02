#!/usr/bin/env bash

part_a() {
    local -a cmd
    local x j inc cycle sum

    x="1"
    cycle="0"
    sum="0"

    while read -ra cmd; do
        case "${cmd[0],,}" in
            noop )  inc="1";;
            addx )  inc="2";;
        esac

        for (( j = 0; j < inc; j++ )); do
            (( cycle++ ))
            (( (cycle - 20) % 40 == 0 )) && \
                (( sum += (cycle * x) ))
        done

        [[ -n "${cmd[1]}" ]] && (( x += cmd[1] ))
    done < "${1}"

    printf '%s\n' "${sum}"
}

part_b() {
    local -a cmd
    local x j inc cycle

    x="1"
    cycle="1"

    while read -ra cmd; do
        case "${cmd[0],,}" in
            noop )  inc="1";;
            addx )  inc="2";;
        esac

        for (( j = 0; j < inc; j++ )); do
            if (( x == cycle || x + 1 == cycle || x + 2 == cycle )); then
                printf '%s' "#"
            else
                printf '%s' "."
            fi

            (( cycle++ ))

            if (( cycle == 41 )); then
                cycle="1"
                printf '\n'
            fi

            [[ -n "${cmd[1]}" ]] && (( x += cmd[1] ))
        done
    done < "${1}"
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
