#!/usr/bin/env bash
# shellcheck disable=SC2178

# Get steps as (x, y, d) "tuple"
# ref(map) x y width height
get_steps() {
    local -n arr="${1}"
    local x y xn yn d
    x="${2}"
    y="${3}"

    while (( x >= 0 && x < ${4} && yn >= 0 && yn < ${5} )); do
        printf '%s %s %s\n' "${x}" "${y}" "${d:=0}"
        case "${d}" in
            0 | 2 ) (( xn = x, yn = y + (d == 0 ? -1 : 1) ));;
            1 | 3 ) (( xn = x + (d == 1 ? 1 : -1), yn = y ));;
        esac
        (( xn >= 0 && xn < ${4} && yn >= 0 && yn < ${5} )) || break
        if (( arr[yn * ${4} + xn] == 1 )); then
            (( d = (d + 1) % 4 ))
        else
            (( x = xn, y = yn ))
        fi
    done
}

# Get count unique positions from steps array
# ref(steps) w
count_unique() {
    local -n arr="${1}"
    local -a pos
    local x y

    while read -r x y _; do
        (( pos[y * ${2} + x]++ ))
    done < <(printf '%s\n' "${arr[@]}")

    printf '%s\n' "${#pos[@]}"
}

# Determine if a given start position causes an infinite loop
# ref(map) x y direction width height
contains_loop() {
    local -n arr="${1}"
    local -A bonk
    local x y xn yn d
    x="${2}"
    y="${3}"
    d="${4}"

    while (( x >= 0 && x < ${5} && y >= 0 && y < ${6} )); do
        case "${d}" in
            0 | 2 ) (( xn = x, yn = y + (d == 0 ? -1 : 1) ));;
            1 | 3 ) (( xn = x + (d == 1 ? 1 : -1), yn = y ));;
        esac
        (( xn >= 0 && xn < ${5} && yn >= 0 && yn < ${6} )) || return 1
        if (( arr[yn * ${5} + xn] == 1 )); then
            (( bonk["${xn} ${yn} ${d}"]++ ))
            (( bonk["${xn} ${yn} ${d}"] > 1 )) && return 0
            (( d = (d + 1) % 4 ))
        else
            (( x = xn, y = yn ))
        fi
    done

    return 1
}

main() {
    local -a map steps tried looped
    local i w h xs ys line xb yb db

    while read -r line; do
        for (( i = 0; i < ${#line}; i++ )); do
            case "${line:i:1}" in
                "." ) map+=( "0" );;
                "#" ) map+=( "1" );;
                "^" ) map+=( "2" ); (( xs = i, ys = h ));;
            esac
        done
        (( w = ${#line}, h++ ))
    done < "${1:-/dev/stdin}"

    mapfile -t steps < <(get_steps "map" "${xs}" "${ys}" "${w}" "${h}")
    count_unique "steps" "${w}"

    for (( i = 1; i < ${#steps[@]}; i++ )); do
        read -r xb yb db <<< "${steps[i]}"
        # try not to repeat yourself
        (( tried[yb * w + xb] > 0 )) && continue

        (( map[yb * w + xb] = 1 ))
        case "${db}" in
            0 | 2 ) (( xs = xb, ys = yb + (db == 0 ? 1 : -1) ));;
            1 | 3 ) (( xs = xb + (db == 1 ? -1 : 1), ys = yb ));;
        esac
        contains_loop "map" "${xs}" "${ys}" "${db}" "${w}" "${h}" \
            && looped+=( "${xb} ${yb} ${db}" )
        (( map[yb * w + xb] = 0, tried[yb * w + xb]++ ))
    done

    printf '%s\n' "${#looped[@]}"
}

main "${@}"
