#!/usr/bin/env bash
# shellcheck disable=SC2178

# part_a
# ref start_x start_y width height
get_path() {
    local -n arr="${1}"
    local -a pos
    local x y xn yn d
    x="${2}"
    y="${3}"
    d="0"

    while (( x >= 0 && x < ${4} && y >= 0 && y < ${5} )); do
        (( pos[y * w + x]++ ))
        case "${d}" in
            0 ) (( xn = x, yn = y - 1 ));;
            1 ) (( xn = x + 1, yn = y ));;
            2 ) (( xn = x, yn = y + 1 ));;
            3 ) (( xn = x - 1, yn = y ));;
        esac
        (( xn >= 0 && xn < ${4} && yn >= 0 && yn < ${5} )) || break
        if (( arr[yn * ${4} + xn] == 1 )); then
            (( d = (d + 1) % 4 ))
        else
            (( x = xn, y = yn ))
        fi
    done

    printf '%s\n' "${!pos[@]}"
}

# part_b
# ref start_x start_y width height
is_loop() {
    local -n arr="${1}"
    local -A vex
    local x y xn yn d
    x="${2}"
    y="${3}"
    d="0"

    while (( x >= 0 && x < ${4} && y >= 0 && y < ${5} )); do
        case "${d}" in
            0 ) (( xn = x, yn = y - 1 ));;
            1 ) (( xn = x + 1, yn = y ));;
            2 ) (( xn = x, yn = y + 1 ));;
            3 ) (( xn = x - 1, yn = y ));;
        esac
        (( xn >= 0 && xn < ${4} && yn >= 0 && yn < ${5} )) || return 1
        if (( arr[yn * ${4} + xn] == 1 )); then
            (( vex["${xn},${yn},${d}"]++ ))
            (( vex["${xn},${yn},${d}"] > 1 )) && return 0
            (( d = (d + 1) % 4 ))
        else
            (( x = xn, y = yn ))
        fi
    done

    return 1
}

main() {
    local -a map unique
    local i w h xinit yinit loops line

    # flatten, get start & dimensions
    while read -r line; do
        for (( i = 0; i < ${#line}; i++ )); do
            case "${line:i:1}" in
                "." )   map+=( "0" );;
                "#" )   map+=( "1" );;
                "^" )   map+=( "2" ); xinit="${i}"; yinit="${h:=0}";;
            esac
        done
        (( w = ${#line}, h++ ))
    done < "${1:-/dev/stdin}"

    mapfile -t unique < <(get_path "map" "${xinit}" "${yinit}" "${w}" "${h}")
    printf '%s\n' "${#unique[@]}"

    for i in "${unique[@]}"; do
        (( i == yinit * w + xinit )) && continue
        (( map[i] = 1 ))
        is_loop "map" "${xinit}" "${yinit}" "${w}" "${h}" && (( loops++ ))
        (( map[i] = 0 ))
    done

    printf '%s\n' "${loops:-0}"
}

main "${@}"
