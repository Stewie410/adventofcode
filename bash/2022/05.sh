#!/usr/bin/env bash
#
# 2022-12-05

part_a() {
    local -a stacks
    local scount line j field from to count

    scount="$(head -1 "${1}" | wc --chars)"
    (( scount /= 4 ))

    while read -r line; do
        case "${line}" in
            *\[* )
                for (( j = 0; j < scount; j++ )); do
                    field="${line:(i * 4):4}"
                    stacks["${i}"]+="${field//[^[:upper:]]/}"
                done
                ;;
            *move* )
                count="${line##*move }"
                count="${count% from*}"

                from="${line##*from }"
                from="${from% to*}"
                (( from-- ))

                to="${line##*to }"
                (( to-- ))

                for (( j = 0; j < count; j++ )); do
                    stacks["${to}"]="${field:$j:1}${stacks["$to"]}"
                done

                stacks["${from}"]="${field:$count}"
                ;;
        esac
    done < <(sed '/\[/s/\s/,/g' "${1}")

    printf '%s\n' "${stacks[@]}" | \
        cut --characters="1" | \
        paste --serial --delimiter='\0'
}

part_b() {
    local -a stacks
    local scount line j field from to count

    scount="$(head -1 "${1}" | wc --chars)"
    (( scount /= 4 ))

    while read -r line; do
        case "${line}" in
            *\[* )
                for (( j = 0; j < scount; j++ )); do
                    field="${line:(i * 4):4}"
                    stacks["${i}"]="${field//[^[:upper:]]/}"
                done
                ;;
            *move* )
                count="${line##*move }"
                count="${count% from*}"

                from="${line##*from }"
                from="${from% to*}"
                (( from-- ))

                to="${line##*to }"
                (( to-- ))

                field="${stacks["$from"]}"
                stacks["${to}"]="${field:0:$count}${stacks["$to"]}"
                stacks["${from}"]="${field:$count}"
                ;;
        esac
    done < <(sed '/\[/s/\s/,/g' "${1}")

    printf '%s\n' "${stacks[@]}" | \
        cut --characters="1" | \
        paste --serial --delimiters='\0'
}
