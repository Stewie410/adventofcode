#!/usr/bin/env bash

get_points() {
    local a b
    while read -r a _ b; do
        printf '%s %s %s %s\n' "${a%,*}" "${a#*,}" "${b%,*}" "${b#*,}"
    done < "${1}"
}

get_size() {
    local -n arr="${1}"
    local i x1 x2 y1 y2 mx my

    for i in "${arr[@]}"; do
        read -r x1 y1 x2 y2 <<< "${i}"
        (( x1 > mx )) && mx="${x1}"
        (( x2 > mx )) && mx="${x2}"
        (( y1 > my )) && my="${y1}"
        (( y2 > my )) && my="${y2}"
    done

    printf '%s %s\n' "${mx}" "${my}"
}

# ref coords width
draw() {
    local -n arr="${1}"
    local x y w x1 x2 y1 y2

    read -r x1 x2 y1 y2 w <<< "${2} ${3}"
}

p1() {
    local -a map points
    local i j width h x y x1 x2 y1 y2 count

    mapfile -t points < <(get_points "${1}")
    read -r width h < <(get_size points)

    for i in "${points[@]}"; do
        read -r x1 y1 x2 y2 <<< "${i}"
        # part_a() only?
        (( x1 != x2 && y1 != y2 )) && continue
        if (( x1 > x2 )); then
            (( x1 = x1 + x2 ))
            (( x2 = x1 - x2 ))
            (( x1 = x1 - x2 ))
        fi
        if (( y1 > y2 )); then
            (( y1 = y1 + y2 ))
            (( y2 = y1 - y2 ))
            (( y1 = y1 - y2 ))
        fi

        for (( y = y1; y <= y2; y++ )); do
            for (( x = x1; x <= x2; x++ )); do
                (( map[y * width + x ]++ ))
            done
        done
    done

    for j in "${map[@]}"; do
        (( count += j >= 2 ))
    done

    printf '%s\n' "${count}"
}

main() {
    set -- "${1:-/dev/stdin}"
    p1 "${1}"
}

main "${@}"
