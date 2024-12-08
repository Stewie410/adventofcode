#!/usr/bin/env bash
# shellcheck disable=SC2178

# ref(in) ref(out) ref(xinit) ref(yinit)
flatten() {
    local -n in="${1}"
    local -n out="${2}"
    local -n xs="${3}"
    local -n ys="${4}"
    local c

    for (( y = 0; y < ${#in[@]}; y++ )); do
        for (( x = 0; x < ${#in[0]}; x++ )); do
            case "${in[y]:x:1}" in
                "." )   c="0";;
                "#" )   c="1";;
                "^" )   c="2"; xs="${x}"; ys="${y}";;
            esac
            out+=( "${c}" )
        done
    done
}

# part_a
# ref start_x start_y width height
get_path() {
    local -n arr="${1}"
    local -a pos
    local x y w h d next
    x="${2}"
    y="${3}"
    w="${4}"
    h="${5}"
    d="0"

    while (( x >= 0 && x < w && y >= 0 && y < h )); do
        (( pos[y * w + x]++ ))
        # printf '%s,%s\n' "${y}" "${x}" >&2
        case "${d}" in
            0 ) (( next = (y - 1) * w + x )); (( y - 1 < 0 )) && break;;
            1 ) (( next = y * w + (x + 1) )); (( x + 1 > w )) && break;;
            2 ) (( next = (y + 1) * w + x )); (( y + 1 > h )) && break;;
            3 ) (( next = y * w + (x - 1) )); (( x - 1 < 0 )) && break;;
        esac
        (( next >= 0 && next <= ${#arr[@]} )) || break
        if (( arr[next] == 1 )); then
            (( d = (d + 1) % 4 ))
        else
            case "${d}" in
                0 ) (( y-- ));;
                1 ) (( x++ ));;
                2 ) (( y++ ));;
                3 ) (( x-- ));;
            esac
        fi
    done

    printf '%s\n' "${!pos[@]}"
}

# part_b
# ref start_x start_y width height
is_loop() {
    local -n arr="${1}"
    local -A vex
    local x y xn yn w h d next
    x="${2}"
    y="${3}"
    w="${4}"
    h="${5}"
    d="0"

    while (( x >= 0 && x < w && y >= 0 && y < h )); do
        case "${d}" in
            0 ) (( xn = x, yn = y - 1 ));;
            1 ) (( xn = x + 1, yn = y ));;
            2 ) (( xn = x, yn = y + 1 ));;
            3 ) (( xn = x - 1, yn = y ));;
        esac
        (( xn >= 0 && xn < w && yn >= 0 && yn < h )) || return 1
        if (( arr[yn * w + xn] == 1 )); then
            (( vex["${xn},${yn},${d}"]++ ))
            (( vex["${xn},${yn},${d}"] > 1 )) && return 0
            (( d = (d + 1) % 4 ))
        else
            (( x = xn, y = yn ))
        fi
    done

    return 1
}

solution() {
    local -a raw map unique
    local i w h xinit yinit loops

    mapfile -t raw < "${1}"
    flatten "raw" "map" "xinit" "yinit"
    w="${#raw[0]}"
    h="${#raw[@]}"
    unset raw

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

main() {
    if [[ -z "${1}" ]]; then
        printf 'Must specify input file as arg[0]\n' >&2
        return 1
    fi
    solution "${1}"
}

main "${@}"
