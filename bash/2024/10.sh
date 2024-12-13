#!/usr/bin/env bash

# ref(map) width height y x last_val
get_trails() {
    local -n arr="${1}"
    local x y w h last current
    (( w = ${2}, h = ${3}, y = ${4}, x = ${5}, last = ${6} ))
    (( y >= 0 && y < h && x >= 0 && x < w )) || return 1
    (( current = arr[y * w + x] ))
    (( current >= 0 && current < 10 && current == (last + 1) )) || return 1

    if (( current == 9 )); then
        printf '%s\n' "$(( y * w + x ))"
        return 0
    fi

    get_trails "${@:1:3}" "$(( y - 1 ))" "${x}" "${current}"
    get_trails "${@:1:3}" "$(( y + 1 ))" "${x}" "${current}"
    get_trails "${@:1:3}" "${y}" "$(( x - 1 ))" "${current}"
    get_trails "${@:1:3}" "${y}" "$(( x + 1 ))" "${current}"
}

main() {
    local -a data map starts unique any
    local i y x w h sum_a sum_b

    mapfile -t data < "${1:-/dev/stdin}"
    (( w = "${#data[0]}", h = ${#data[@]} ))
    for (( y = 0; y < h; y++ )); do
        for (( x = 0; x < w; x++ )); do
            # '.' case needed for test input only
            case "${data[y]:x:1}" in
                '.' )   map+=( "-1" ); continue;;
                '0' )   (( starts[y * w + x] = 0 ));;
            esac
            map+=( "${data[y]:x:1}" )
        done
    done
    unset data

    for i in "${!starts[@]}"; do
        mapfile -t any < <(get_trails \
            "map" "${w}" "${h}" "$(( i / w ))" "$(( i % w))" "-1" \
        )
        unique=()
        for j in "${any[@]}"; do
            (( unique[j]++ ))
        done
        (( sum_a += ${#unique[@]}, sum_b += ${#any[@]} ))
    done

    printf '%s\n' "${sum_a:-0}" "${sum_b:-0}"
}

main "${@}"
