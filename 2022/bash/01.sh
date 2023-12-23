#!/usr/bin/env bash
#
# 2022-12-01

filter() {
    awk '
        /[0-9]/ { current = current + $0 }
        /^\s*$/ { print current; current = 0 }
        END { print current }
    ' "${1}" | \
        sort --numeric-sort --reverse
}

part_a() {
    filter "${1}" | \
        sed '1q'
}

part_b() {
    filter "${1}" | \
        sed '3q' | \
        paste --serial --delimiters="+" | \
        bc
}
