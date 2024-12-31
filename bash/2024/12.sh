#!/usr/bin/env bash

# y x
# @return [N, S, W, E]
neighbors() {
    printf '%d %d\n' \
        "$(( ${1} - 1 ))" "${2}" \
        "$(( ${1} + 1 ))" "${2}" \
        "${1}" "$(( ${2} - 1 ))" \
        "${1}" "$(( ${2} + 1 ))" \
        ;
}

# y x
# @return [NW, N, NE, E, SE, S, SW, W]
surrounding() {
    printf '%d %d\n' \
        "$(( ${1} - 1 ))" "$(( ${2} - 1 ))" \
        "$(( ${1} - 1 ))" "$(( ${2} + 0 ))" \
        "$(( ${1} - 1 ))" "$(( ${2} + 1 ))" \
        "$(( ${1} + 0 ))" "$(( ${2} + 1 ))" \
        "$(( ${1} + 1 ))" "$(( ${2} + 1 ))" \
        "$(( ${1} + 1 ))" "$(( ${2} + 0 ))" \
        "$(( ${1} + 1 ))" "$(( ${2} - 1 ))" \
        "$(( ${1} + 0 ))" "$(( ${2} - 1 ))" \
        ;
}

# ref(data) width height
flatten() {
    local -n arr="${1}"
    local x y w h c key mod
    (( w = ${2}, h = ${3} ))
    key="ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    for (( y = 0; y < h; y++ )); do
        for (( x = 0; x < w; x++ )); do
            c="${arr[y]:x:1}"
            mod="${key%"${c}"*}"
            printf '%d\n' "${#mod}"
        done
    done
}

# This is truly awful and should be changed
# ref(map) width height
get_groups() {
    local -n arr="${1}"
    local -a seen cache queue copy
    local i x y w h xn yn xb yb
    (( w = ${2}, h = ${3} ))

    for (( y = 0; y < h; y++ )); do
        for (( x = 0; x < w; x++ )); do
            (( seen[y * w + x] > 0 )) && continue

            queue=( "$(( y * w + x ))" )
            cache=()
            (( cache[y * w + x]++, seen[y * w + x]++ ))

            while (( ${#queue[@]} > 0 )); do
                copy=()
                for i in "${queue[@]}"; do
                    (( yb = i / w, xb = i % w ))
                    while read -r yn xn; do
                        (( yn >= 0 && yn < h && xn >= 0 && xn < w )) || continue
                        (( arr[yb * w + xb] == arr[yn * w + xn] )) || continue
                        (( cache[yn * w + xn] > 0 )) && continue
                        copy+=( "$(( yn * w + xn ))" )
                        (( cache[yn * w + xn]++, seen[yn * w + xn]++ ))
                    done < <(neighbors "${yb}" "${xb}")
                done
                queue=( "${copy[@]}" )
            done

            printf '%s\n' "${!cache[*]}"
        done
    done
}

# ref(map) width height group...
get_perimeter() {
    local -n arr="${1}"
    local -a nodes
    local i j x y w h psum csum
    (( w = ${2}, h = ${3} ))

    if (( $# == 4 )); then
        printf '%d %d\n' "4" "4"
        return 0
    fi

    for i in "${@:4}"; do
        # NW N NE E SE S SW W -> 0 is edge
        mapfile -t nodes < <(surrounding "$(( i / w ))" "$(( i % w ))")
        for (( j = 0; j < ${#nodes[@]}; j++ )); do
            read -r y x <<< "${nodes[j]}"
            if ! (( y >= 0 && y < h && x >= 0 && x < w )); then
                (( nodes[j] = 1 ))
            else
                (( nodes[j] = arr[y * w + x] != arr[i] ))
            fi
        done

        # perimiter
        (( psum += nodes[1] + nodes[3] + nodes[5] + nodes[7] ))

        # corners: outer, NW NE SW SE
        (( csum += (nodes[1] && nodes[7]) + (nodes[1] && nodes[3]) ))
        (( csum += (nodes[5] && nodes[7]) + (nodes[5] && nodes[3]) ))

        # corners: inner, NW NE SW SE
        (( csum += (nodes[1] + nodes[7] == 0) && nodes[0] ))
        (( csum += (nodes[1] + nodes[3] == 0) && nodes[2] ))
        (( csum += (nodes[5] + nodes[7] == 0) && nodes[6] ))
        (( csum += (nodes[5] + nodes[3] == 0) && nodes[4] ))
    done

    printf '%d %d\n' "${psum}" "${csum}"
}

main() {
    local -a data map group
    local i x y w h edges corners

    mapfile -t data < "${1:-/dev/stdin}"
    (( w = ${#data[0]}, h = ${#data[@]} ))
    mapfile -t map < <(flatten "data" "${w}" "${h}")
    unset data

    while read -ra group; do
        read -r edges corners < <(get_perimeter "map" "${w}" "${h}" "${group[@]}")
        (( cost1 += ${#group[@]} * edges, cost2 += ${#group[@]} * corners ))
    done < <(get_groups "map" "${w}" "${h}")

    printf '%d\n' "${cost1:-0}" "${cost2:-0}"
}

main "${@}"
