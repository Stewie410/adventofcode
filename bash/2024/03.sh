#!/usr/bin/env bash

main() {
    local -a lines
    local i enable mul any sum

    enable="1"
    mapfile -t lines < "${1:-/dev/stdin}"

    for (( i = 0; i < ${#lines[@]}; i++ )); do
        while [[ "${lines[i]}" =~ (do(n\'t)?\(\)|mul\(([0-9]{1,3}),([0-9]{1,3})\)) ]]; do
            case "${BASH_REMATCH[0]}" in
                "do()" )    enable="1";;
                "don't()" ) enable="0";;
                mul* )
                    (( mul = BASH_REMATCH[-2] * BASH_REMATCH[-1] ))
                    (( any += mul, sum += enable ? mul : 0 ))
                    ;;
            esac
            lines[i]="${lines[i]#*"${BASH_REMATCH[0]}"}"
        done
    done

    printf '%s\n' "${any}" "${sum}"
}

main "${@}"
