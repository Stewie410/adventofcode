#!/usr/bin/env bash

main() {
    local -a lines
    local w h
    mapfile -t lines < "${1:-/dev/stdin}"
    (( w = ${#lines[0]}, h = ${#lines[@]} ))

    local -a map
    local x y start
    for (( y = 0; y < h; y++ )); do
        for (( x = 0; x < w; x++ )); do
            case "${lines[y]:x:1}" in
                "." )   map+=( 0 );;
                "^" )   map+=( -1 );;
                "S" )   map+=( -2 ); (( start = (y + 1) * w + x ));;
            esac
        done
    done
    (( map[start] = 1 ))

    local p1
    for (( y = 2; y < h; y++ )); do
        for (( x = 0; x < w; x++ )); do
            (( map[y * w + x] == -1 )) || continue
            (( map[(y - 1) * w + x] > 0 )) || continue

            # split
            (( map[y * w + (x - 1)] += map[(y - 1) * w + x] ))
            (( map[y * w + (x + 1)] += map[(y - 1) * w + x] ))
            (( p1++ ))
        done

        for (( x = 0; x < w; x++ )); do
            (( map[y * w + x] >= 0 )) || continue
            (( map[(y - 1) * w + x] > 0 )) || continue

            (( map[y * w + x] += map[(y - 1) * w + x] ))
        done
    done

    local exp p2
    (( y = h - 1, x = w - 1 ))
    exp="${map[*]:(y * w):(y * w + x)}"
    exp="${exp// /+}"
    (( p2 = exp ))

    printf '%d\n' "${p1:-0}" "${p2:-0}"
}

main "${@}"
