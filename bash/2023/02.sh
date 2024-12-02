#!/usr/bin/env bash

solution() {
    local game sum power r g b idx color value

    while read -r game; do
        (( r = 0, g = 0, b = 0, idx++ ))

        while read -r value color; do
            case "${color,,}" in
                red )   (( r < value )) && r="${value}";;
                green ) (( g < value )) && g="${value}";;
                blue )  (( b < value )) && b="${value}";;
            esac
        done < <(tr "," '\n' <<< "${game}")

        if (( r <= 12 && g <= 13 && b <= 14 )); then
            (( sum += idx ))
        fi

        (( power += r * g * b ))
    done < <(sed '/^\s*$/d;s/^.*: //;s/[,;] /,/g' "${1}")

    printf '%d\n' "${sum}" "${power}"
}

main() {
    set -- "${1:-/dev/stdin}"
    solution "${1}"
}

main "${@}"
