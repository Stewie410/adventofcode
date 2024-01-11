#!/usr/bin/env bash
#
# 2021-12-02

part_a() {
    local direction amount x y

    while read -r direction amount; do
        case "${direction,,}" in
            forward )   x="$(( x + amount ))";;
            down )      y="$(( y + amount ))";;
            up )        y="$(( y - amount ))";;
        esac
    done

    printf '%s\n' "$(( x * y ))"
}

part_b() {
    local direction amount x y a

    while read -r direction amount; do
        case "${direction,,}" in
            forward )   x="$(( x + amount ))"; y="$(( y + ( a * amount ) ))";;
            down )      a="$(( a + amount ))";;
            up )        a="$(( a - amount ))";;
        esac
    done < "${1}"

    printf '%s\n' "$(( x * y ))"
}
