#!/usr/bin/env bash

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

main() {
    set -- "${1:-/dev/stdin}"
    get_markers "${1}" "4"
    get_markers "${1}" "14"
}

main "${@}"
