#!/usr/bin/env bash

part_a() {
    local -a lines
    local x y w count word

    mapfile -t lines < "${1}"
    w="${#lines[0]}"

    for (( y = 0; y < ${#lines[@]}; y++ )); do
        for (( x = 0; x < w; x++ )); do
            [[ "${lines[y]:x:1}" != "X" ]] && continue

            # EAST
            if (( x <= w - 3 )); then
                [[ "${lines[y]:x:4}" == "XMAS" ]] && (( count++ ))
            fi

            # WEST
            if (( x >= 3 )); then
                [[ "${lines[y]:x-3:4}" == "SAMX" ]] && (( count++ ))
            fi

            # NORTH
            if (( y >= 3 )); then
                word="${lines[y]:x:1}${lines[y-1]:x:1}${lines[y-2]:x:1}${lines[y-3]:x:1}"
                [[ "${word}" == "XMAS" ]] && (( count++ ))
            fi

            # SOUTH
            if (( y <= ${#lines[@]} - 3 )); then
                word="${lines[y]:x:1}${lines[y+1]:x:1}${lines[y+2]:x:1}${lines[y+3]:x:1}"
                [[ "${word}" == "XMAS" ]] && (( count++ ))
            fi

            # NE
            if (( x <= w - 3 && y >= 3 )); then
                word="${lines[y]:x:1}${lines[y-1]:x+1:1}${lines[y-2]:x+2:1}${lines[y-3]:x+3:1}"
                [[ "${word}" == "XMAS" ]] && (( count++ ))
            fi

            # NW
            if (( x >= 3 && y >= 3 )); then
                word="${lines[y]:x:1}${lines[y-1]:x-1:1}${lines[y-2]:x-2:1}${lines[y-3]:x-3:1}"
                [[ "${word}" == "XMAS" ]] && (( count++ ))
            fi

            # SE
            if (( y <= ${#lines[@]} - 3 && x <= w - 3 )); then
                word="${lines[y]:x:1}${lines[y+1]:x+1:1}${lines[y+2]:x+2:1}${lines[y+3]:x+3:1}"
                [[ "${word}" == "XMAS" ]] && (( count++ ))
            fi

            # SW
            if (( y <= ${#lines[@]} - 3 && x >= 3 )); then
                word="${lines[y]:x:1}${lines[y+1]:x-1:1}${lines[y+2]:x-2:1}${lines[y+3]:x-3:1}"
                [[ "${word}" == "XMAS" ]] && (( count++ ))
            fi
        done
    done

    printf '%s\n' "${count}"
}

part_b() {
    local -a lines
    local x y w count above below

    mapfile -t lines < "${1}"
    w="${#lines[0]}"

    for (( y = 1; y < ${#lines[@]} - 1; y++ )); do
        for (( x = 1; x < w - 1; x++ )); do
            [[ "${lines[y]:x:1}" != "A" ]] && continue

            above="${lines[y-1]:x-1:1}${lines[y-1]:x+1:1}"
            below="${lines[y+1]:x-1:1}${lines[y+1]:x+1:1}"

            [[ "${above}${below}" =~ (MMSS|SSMM|MSMS|SMSM) ]] || continue
            (( count++ ))
        done
    done

    printf '%s\n' "${count}"
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
