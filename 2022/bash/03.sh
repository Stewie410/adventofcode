#!/usr/bin/env bash
#
# 2022-12-03

unique() {
    fold --width="1" <<< "${1}" | \
        awk '!seen[$0]++' | \
        paste --serial --delimiters='\0'
}

part_a() {
    local line total char dict len
    dict='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

    while read -r line; do
        char="$(unique "${line:0:${#line}/2}")$(unique "${line:${#line}/2}")"
        char="$(fold --width="1" <<< "${char}" | awk '!seen[$0]++')"
        len="${dict%${char}*}"
        (( total += ${#len} + 1 ))
    done < "${1}"

    printf '%s\n' "${total}"
}

part_b() {
    local total char dict len a b c
    dict='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

    while read -r a b c; do
        char="$(unique "${a}")$(unique "${b}")$(unique "${c}")"
        char="$(fold --width="1" <<< "${char}" | awk '
            seen[$0]++ && seen[$0] == 3
        ')"
        len="${dict%${char}*}"
        (( total += ${#len} + 1 ))
    done < <(paste --serial --delimiters=" " - - - < "${1}")

    printf '%s\n' "${total}"
}
