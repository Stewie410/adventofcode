#!/usr/bin/env bash

# position velocity width height seconds
get_position() {
    local px py vx vy w h t tx ty
    (( w = ${3}, h = ${4}, t = ${5} ))
    read -r px py <<< "${1}"
    read -r vx vy <<< "${2}"

    (( tx = (px + vx * t) % w, ty = (py + vy * t) % h ))
    (( tx += tx < 0 ? w : 0, ty += ty < 0 ? h : 0 ))

    printf '%d %d\n' "${tx}" "${ty}"
}

# ref(point) ref(velocity) width height
part_a() {
    local -n pos="${1}"
    local -n vel="${2}"
    local -a quad
    local i x y w h result
    (( w = ${3}, h = ${4} ))

    for (( i = 0; i < ${#pos[@]}; i++ )); do
        read -r x y < <(get_position "${pos[i]}" "${vel[i]}" "${w}" "${h}" "100")
        (( y == (h / 2) || x == (w / 2) )) && continue
        (( quad[(y > (h / 2)) * 2 + (x > (w / 2))]++ ))
    done

    for (( i = 0, result = 1; i < 4; i++ )); do
        (( result *= quad[i] ))
    done

    printf '%d\n' "${result}"
}

# width height positions...
print_map() {
    local -a dict
    local i x y w h c
    (( w = ${1}, h = ${2} ))

    for i in "${@:3}"; do
        read -r x y <<< "${i}"
        (( dict[y * w + x]++ ))
    done

    for (( y = 0; y < h; y++ )); do
        for (( x = 0; x < w; x++ )); do
            c=" "
            if (( dict[y * w + x] > 0 )); then
                c="${dict[y * w + x]}"
            fi
            printf '%s' "${c}"
        done
        printf '\n'
    done
}

# width height x_offset y_offset ref(bots)
print_window() {
    local -n dict="${5}"
    local i x y xos yos w h
    (( w = ${1}, h = ${2}, xos = ${3}, yos = ${4} ))

    for (( y = yos; y <= (y + 31) && y < h; y++ )); do
        for (( x = xos; x <= (x + 31) && x < w; x++ )); do
            if [[ -n "${dict[y * w + x]}" ]]; then
                printf 'x'
            else
                printf ' '
            fi
        done
        printf '\n'
    done
}

# From visual solve, looks like all bots are in unique positions in a
# "tree-state"...
#
# width height positions...
contains_tree() {
    local -a bots
    local i x y w h
    (( w = ${1}, h = ${2} ))

    for i in "${@:3}"; do
        read -r x y <<< "${i}"
        (( bots[y * w + x]++ ))
        (( bots[y * w + x] > 1 )) && return 1
    done

    return 0
}

# ref(point) ref(velocity) width height
part_b() {
    local -n pos="${1}"
    local -n vel="${2}"
    local i x y w h seconds
    (( w = ${3}, h = ${4} ))

    for (( seconds = 0; seconds >= 0; seconds++ )); do
        contains_tree "${w}" "${h}" "${pos[@]}" && break
        for (( i = 0; i < ${#pos[@]}; i++ )); do
            pos[i]="$(get_position "${pos[i]}" "${vel[i]}" "${w}" "${h}" "1")"
        done
    done

    printf '%d\n' "${seconds}"
}

main() {
    local -a point velocity
    local i x y w h line part

    while read -r line; do
        # parse points
        part="${line% *}"
        part="${part:2}"
        (( x = ${part%,*}, y = ${part##*,} ))
        (( w = x > w ? x : w, h = y > h ? y : h ))
        point+=( "${part//,/ }" )

        # parse velocities
        part="${line##*=}"
        velocity+=( "${part//,/ }" )
    done < "${1:-/dev/stdin}"
    (( w++, h++ ))

    part_a "point" "velocity" "${w}" "${h}"
    # skip part_b() for test data
    (( w == 11 && h == 7 )) && return
    part_b "point" "velocity" "${w}" "${h}"
}

main "${@}"
