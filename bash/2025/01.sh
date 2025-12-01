#!/usr/bin/env bash

main() {
    local line pos flip amt p1 p2
    pos="50"
    while read -r line; do
        amt="${line:1}"
        case "${line:0:1}" in
            "L" )
                (( flip = (100 - pos) % 100 ))
                (( p2 += (flip + amt) / 100 ))
                (( pos = (pos - amt) % 100 ))
                (( pos = pos < 0 ? pos + 100 : pos ))
                ;;
            "R" )
                (( p2 += (pos + amt) / 100 ))
                (( pos = (pos + amt) % 100 ))
                ;;
        esac
        (( pos == 0 )) && (( p1++ ))
    done < "${1:-/dev/stdin}"

    printf '%d\n' "${p1:-0}" "${p2:-0}"
}

main "${@}"
