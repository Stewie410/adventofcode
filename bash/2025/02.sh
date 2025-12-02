#!/usr/bin/env bash

main() {
    local -a range
    IFS=',' read -ra range < "${1:-/dev/stdin}"

    local i lo hi len p1 p2
    while IFS='-' read -r lo hi; do
        for (( i = lo; i <= hi; i++ )); do
            (( len = ${#i} / 2 ))
            if (( ${#i} % 2 == 0 )) && [[ "${i:0:len}" == "${i:len}" ]]; then
                (( p1 += i, p2 += i ))
                continue
            fi

            for (( ; len >= 1; len-- )); do
                [[ "${i}" =~ ^("${i:0:len}"){2,}$ ]] || continue
                (( p2 += i ))
            done
        done
    done < <(printf '%s\n' "${range[@]}")

    printf '%d\n' "${p1:-0}" "${p2:-0}"
}

main "${@}"
