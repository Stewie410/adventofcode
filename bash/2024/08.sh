#!/usr/bin/env bash

# ref(map) w h
print_map() {
    local -n arr="${1}"
    local y x

    for (( y = 0; y < ${3}; y++ )); do
        for (( x = 0; x < ${2}; x++ )); do
            printf '%s' "${arr[y * ${2} + x]}"
        done
        printf '\n'
    done
}

main() {
    local -A nodes
    local -a data map copy anti_a anti_b
    local x y i j k jx jy kx ky dx dy w h

    mapfile -t data < "${1:-/dev/stdin}"
    w="${#data[0]}"
    h="${#data[@]}"

    # build map and hashtable of nodes
    for (( y = 0; y < h; y++ )); do
        for (( x = 0; x < w; x++ )); do
            map+=( "${data[y]:x:1}" )
            if [[ "${map[-1]}" != "." ]]; then
                nodes["${map[-1]}"]+="$(( y * w + x )) "
            fi
        done
    done

    for i in "${!nodes[@]}"; do
        read -ra copy <<< "${nodes["${i}"]}"
        (( ${#copy[@]} == 1 )) && return 0

        for (( j = 0; j < ${#copy[@]}; j++ )); do
            for (( k = j + 1; k < ${#copy[@]}; k++ )); do
                (( jy = copy[j] / h, jx = copy[j] % w ))
                (( ky = copy[k] / h, kx = copy[k] % w ))

                (( anti_b[jy * w + jx]++, anti_b[ky * w + kx]++ ))

                (( dy = jy - ky, dx = jx - kx ))

                (( jy += dy, jx += dx ))
                (( ky -= dy, kx -= dx ))

                (( 0 <= jx && jx < w && 0 <= jy && jy < h )) \
                    && (( anti_a[jy * w + jx]++ ))
                (( 0 <= kx && kx < w && 0 <= ky && ky < h )) \
                    && (( anti_a[ky * w + kx]++ ))

                # j - k
                (( y = jy, x = jx ))
                while (( x >= 0 && x < w && y >= 0 && y < h )); do
                    (( anti_b[y * w + x]++ ))
                    (( x += dx, y += dy ))
                done

                # k - j
                (( y = ky, x = kx ))
                while (( x >= 0 && x < w && y >= 0 && y < h )); do
                    (( anti_b[y * w + x]++ ))
                    (( x -= dx, y -= dy ))
                done
            done
        done
    done

    printf '%s\n' "${#anti_a[@]}" "${#anti_b[@]}"
}

main "${@}"
