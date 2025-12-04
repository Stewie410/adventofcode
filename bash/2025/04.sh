#!/usr/bin/env bash

# ref(map), x, y, w, h
can_access() {
    local -n arr="${1}"
    local x y w h u d l r
    (( x = ${2}, y = ${3}, w = ${4}, h = ${5} ))
    (( u = y - 1 >= 0, d = y + 1 < h ))
    (( l = x - 1 >= 0, r = x + 1 < w ))

    local count
    (( count += l == 1 && arr[y * w + (x - 1)] == 1 ))              # W
    (( count += r == 1 && arr[y * w + (x + 1)] == 1 ))              # E
    if (( u == 1 )); then
        (( count += arr[(y - 1) * w + x] ))                         # N
        (( count += l == 1 && arr[(y - 1) * w + (x - 1)] == 1 ))    # NW
        (( count += r == 1 && arr[(y - 1) * w + (x + 1)] == 1 ))    # NE
    fi

    (( count < 4 )) || return 1

    if (( d == 1 )); then
        (( count += arr[(y + 1) * w + x] ))                         # S
        (( count += l == 1 && arr[(y + 1) * w + (x - 1)] == 1 ))    # SW
        (( count += r == 1 && arr[(y + 1) * w + (x + 1)] == 1 ))    # SE
    fi

    (( count < 4 )) && return 0
    return 1
}

main() {
    local -a lines map
    local i w h line

    mapfile -t lines < "${1:-/dev/stdin}"
    (( w = ${#lines[0]}, h = ${#lines[@]} ))
    for line in "${lines[@]}"; do
        for (( i = 0; i < w; i++ )); do
            case "${line:i:1}" in
                '.' )   map+=( 0 );;
                '@' )   map+=( 1 );;
            esac
        done
    done
    unset lines

    local -a state remove
    local x y

    while true; do
        remove=()
        for (( y = 0; y < h; y++ )); do
            for (( x = 0; x < w; x++ )); do
                (( map[y * w + x] == 1 )) || continue
                can_access "map" "${x}" "${y}" "${w}" "${h}" \
                    && remove+=( "$(( y * w + x))" )
            done
        done
        (( ${#remove[@]} == 0 )) && break

        for i in "${remove[@]}"; do
            (( map[i] = 0 ))
        done
        state+=( "${#remove[@]}" )
    done

    local total
    for i in "${state[@]}"; do
        (( total += i ))
    done

    printf '%d\n' "${state[0]}" "${total}"
}

main "${@}"
