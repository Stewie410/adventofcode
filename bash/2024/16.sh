#!/usr/bin/env bash

# position width direction score
adjacent() {
    local -a dirs vals
    local x y xn yn w i
    (( w = ${2} ))
    (( y = ${1} / w, x = ${1} % w ))

    dirs=( "${4}" "$(( (${4} + 5) % 4 ))" "$(( (d + ${4}) % 4 ))" )
    vals=( "$(( ${5} + 1 ))" "$(( ${5} + 1001 ))" "$(( ${5} + 1001 ))" )

    for i in 0 1 2; do
        case "${dirs[i]}" in
            0 ) (( xn = x, yn = y - 1 ));;
            1 ) (( xn = x + 1, yn = y ));;
            2 ) (( xn = x, yn = y + 1 ));;
            3 ) (( xn = x - 1, yn = y ));;
        esac
        printf '%s %s %s %s\n' "${yn}" "${xn}" "${dirs[i]}" "${vals[i]}"
    done
}

# bfs
# ref(map) width height start end
part_a() {
    local -n arr="${1}"
    local -a queue copy scores
    local i x y w h d xn yn dn sn start stop pos next
    (( w = ${2}, h = ${3}, start = ${4}, stop = ${5} ))

    # (pos, direction, score)[]
    # d = [N, E, S, W] -> nd = (d + 5) % 4
    queue=( "${start} 1" )
    (( scores[start] = 0 ))

    while (( ${#queue[@]} > 0 )); do
        copy=()
        while read -r pos d; do
            while read -r y x dn sn; do
                (( next = yn * w + xn ))
                [[ "${arr[next]}" =~ [E\.] ]] || continue
                (( scores[next] <= sn )) && continue
                (( scores[next] = sn ))
                copy+=( "${next} ${dn}" )
            done < <(adjacent "${pos}" "${w}" "${d}" "${scores[pos]}")
        done < <(printf '%s\n' "${queue[@]}")
        queue=( "${copy[@]}" )
    done

    for i in "${!scores[@]}"; do
        printf '%d: %d\n' "${i}" "${scores[i]}" >&2
    done

    printf '%d\n' "${scores[stop]:-0}"
}

main() {
    local -a map
    local x y w h line start end

    while read -r line; do
        (( w = ${#line}, h++ ))
        for (( x = 0; x < w; x++ )); do
            case "${line:x:1}" in
                "S" )   start="${#map[@]}";;
                "E" )   end="${#map[@]}";;
            esac
            map+=( "${line:x:1}" )
        done
    done < "${1:-/dev/stdin}"

    printf 'Width: %d\nHeight: %d\n' "${w}" "${h}"
    printf 'Start: %d\nEnd: %d\nMap: %s' "${start}" "${end}" "${map[*]}"

    # part_a "map" "${w}" "${h}" "${start}" "${end}"
}

main "${@}"
