#!/usr/bin/env bash

flash() {
    (( flashes++ ))
    stack["$(( y * 10 + x ))"]="-1"

    (( y - 1 >= 0 && stack[(y - 1) * 10 + x] != -1 )) && \
        (( stack[(y - 1) * 10 + x]++ ))
    (( y + 1 < 10 && stack[(y + 1) * 10 + x] != -1 )) && \
        (( stack[(y + 1) * 10 + x]++ ))
    (( x - 1 >= 0 && stack[y * 10 + (x - 1)] != -1 )) && \
        (( stack[y * 10 + (x - 1)]++ ))
    (( x + 1 < 10 && stack[y * 10 + (x + 1)] != -1 )) && \
        (( stack[y * 10 + (x + 1)]++ ))

    (( x - 1 >= 0 && y - 1 >= 0 && stack[(y - 1) * 10 + (x - 1)] != -1 )) && \
        (( stack[(y - 1) * 10 + (x - 1)]++ ))
    (( x + 1 < 10 && y - 1 >= 0 && stack[(y - 1) * 10 + (x + 1)] != -1 )) && \
        (( stack[(y - 1) * 10 + (x + 1)]++ ))
    (( x - 1 >= 0 && y + 1 < 10 && stack[(y + 1) * 10 + (x - 1)] != -1 )) && \
        (( stack[(y + 1) * 10 + (x - 1)]++ ))
    (( x + 1 < 10 && y + 1 < 10 && stack[(y + 1) * 10 + (x + 1)] != -1 )) && \
        (( stack[(y + 1) * 10 + (x + 1)]++ ))
}

print_board() {
    local a b

    for (( a = 0; a < 10; a++ )); do
        for (( b = 0; b < 10; b++ )); do
            printf '%s' "${stack[$(( a * 10 + b))]/0/_}"
        done
        printf '\n'
    done
    printf '\n'
}

part_a() {
    local -a stack
    local flashes j k x y
    flashes="0"

    mapfile -t stack < <(fold --width="1" "${1}")
    print_board

    for j in {0..99}; do
        for k in {0..99}; do
            (( stack[k]++ ))
        done

        k="1"
        while (( k == 1 )); do
            k="0"
            for (( y = 0; y < 10; y++ )); do
                for (( x = 0; x < 10; x++ )); do
                    (( stack[y * 10 + x] == -1 )) && continue
                    if (( stack[y * 10 + x] > 9 )); then
                        flash
                        j="1"
                    fi
                done
            done
        done

        for k in {0..99}; do
            (( stack[k] == -1 )) && stack["${k}"]="0"
        done

        print_board
    done

    printf '%s\n' "${flashes}"
}

part_b() {
    local -a stack
    local j k x y

    mapfile -t stack < <(fold --width="1" "${1}")
    print_board

    for (( j = 1; j > 0; j++ )); do
        for k in {0..99}; do
            (( stack[k]++ ))
        done

        k="1"
        while (( k == 1 )); do
            k="0"
            for (( y = 0; y < 10; y++ )); do
                for (( x = 0; x < 10; x++ )); do
                    (( stack[y * 10 + x] == -1 )) && continue
                    if (( stack[y * 10 + x] > 9 )); then
                        flash
                        j="1"
                    fi
                done
            done
        done

        for k in {0..99}; do
            (( stack[k] == -1 )) && stack["${k}"]="0"
        done

        print_board

        if ! grep --quiet '[^0 ]' <<< "${stack[@]}"; then
            printf '%s\n' "${j}"
            return 0
        fi
    done

    return 1
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
