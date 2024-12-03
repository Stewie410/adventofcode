#!/usr/bin/env bash

main() {
    local direction amount x ay by z

    while read -r direction amount; do
        case "${direction,,}" in
            forward )   (( x += amount, by += z * amount ));;
            down )      (( ay += amount, z += amount ));;
            up )        (( ay -= amount, z -= amount ));;
        esac
    done < "${1:-/dev/stdin}"

    printf '%s\n' "$(( x * ay ))" "$(( x * by ))"
}

main "${@}"
