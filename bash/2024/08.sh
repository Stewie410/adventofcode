#!/usr/bin/env bash
# shellcheck disable=SC2178

# nodes ref(out_a) ref(out_b) width height
calc_anti() {
    local -n out_a="${2}"
    local -n out_b="${3}"
    local -a nodes
    local i j k w h o x1 y1 x2 y2 dx dy xn yn

    w="${4}"
    h="${5}"

    read -ra nodes <<< "${1}"
    (( ${#nodes[@]} == 1 )) && return 1

    for (( i = 0; i < ${#nodes[@]}; i++ )); do
        (( y1 = ${nodes[i]%,*}, x1 = ${nodes[i]#*,} ))
        for (( j = i + 1; j < ${#nodes[@]}; j++ )); do
            (( y2 = ${nodes[j]%,*}, x2 = ${nodes[j]#*,} ))
            (( dx = x1 - x2, dy = y1 - y2 ))

            for (( o = 0; ; o++ )); do
                (( xn = x1 + dx * o, yn = y1 + dy * o ))
                (( xn >= 0 && xn < w && yn >= 0 && yn < h )) || break
                (( o == 1 )) && (( out_a[yn * w + xn]++ ))
                (( out_b[yn * w + xn]++ ))
            done

            for (( o = 0; ; o++ )); do
                (( xn = x2 - dx * o, yn = y2 - dy * o ))
                (( xn >= 0 && xn < w && yn >= 0 && yn < h )) || break
                (( o == 1 )) && (( out_a[yn * w + xn]++ ))
                (( out_b[yn * w + xn]++ ))
            done
        done
    done
}

main() {
    local -A towers
    local -a hta htb
    local w h i line class

    # parse, get dimensions
    while read -r line; do
        (( w = ${#line}, h++ ))
        [[ "${line}" =~ [^\.] ]] || continue
        for (( i = 0; i < ${#line}; i++ )); do
            [[ "${line:i:1}" != "." ]] || continue
            towers["${line:i:1}"]+="$(( h - 1 )),${i} "
        done
    done < "${1:-/dev/stdin}"

    for class in "${towers[@]}"; do
        calc_anti "${class}" "hta" "htb" "${w}" "${h}"
    done

    printf '%s\n' "${#hta[@]}" "${#htb[@]}"
}

main "${@}"
