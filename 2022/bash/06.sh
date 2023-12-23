#!/usr/bin/env bash
#
# 2022-12-06

get_markers() {
    local j line length count
    length="${2}"

    while read -r line; do
        for (( j = 0; j <= ${#line}; j++ )); do
            count="$(fold --width="1" <<< "${line:$j:$length}" | \
                awk '!seen[$0]++' | \
                wc --lines \
            )"

            if (( count == length )); then
                printf '%s\n' "$(( j + length ))"
                break
            fi
        done
    done < "${1}"
}

part_a() {
    get_markers "${1}" "4"
}

part_b() {
    get_markers "${1}" "14"
}
