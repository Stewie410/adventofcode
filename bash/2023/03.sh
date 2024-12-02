#!/usr/bin/env bash

solution() {
    local -A candidates
    local -a map
    local x y px py width height parts ratios

    mapfile -t map < <(fold --width="1" "${1}")
    width="$(wc --max-line-length < "${1}")"
    height="$(wc --lines < "${1}")"

    for (( y = 0; y < height; y++ )); do
        for (( x = 0; x < width; x++ )); do
            [[ "${map[y * width + x]}" =~ [0-9] ]] || continue

            unset num
            while (( x < width )) && [[ "${map[y * width + x]}" =~ [0-9] ]]; do
                num+="${map[y * width + x]}"
                (( x++ ))
            done

            for (( py = y - 1; py <= y + 1; py++ )); do
                for (( px = x - ${#num} - 1; px <= x; px++ )); do
                    if [[ "${map[py * width + px]:-0}" =~ [^0-9\.] ]]; then
                        (( parts += num ))
                        [[ "${map[py * width + px]:-0}" == '*' ]] && \
                            candidates["${py},${px}"]+="${num},"
                        break 2
                    fi
                done
            done
        done
    done

    for x in "${candidates[@]}"; do
        mapfile -t map < <(tr "," '\n' <<< "${x%,*}")
        (( ${#map[@]} == 2 )) && (( ratios += map[0] * map[1] ))
    done

    printf '%d\n' "${parts}" "${ratios}"
}

main() {
    set -- "${1:-/dev/stdin}"
    solution "${1}"
}

main "${@}"
