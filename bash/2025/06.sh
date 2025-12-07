#!/usr/bin/env bash

# ref(lines), ref(out)
p2() {
    local -n data="${1}"
    local -n cols="${2}"

    local i len
    for i in "${data[@]}"; do
        (( ${#i} > len )) && len="${#i}"
    done

    local j char csv slice
    for (( i = 0; i < len; i++ )); do
        slice=""
        for j in "${data[@]}"; do
            char="${j:i:1}"
            slice+="${char:- }"
        done
        if [[ "${slice}" == *[[:digit:]]* ]]; then
            csv+="${slice},"
        else
            cols+=( "${csv%,}" )
            csv=""
        fi
    done
    cols+=( "${csv%,}" )
}

# ref(lines), ref(out)
p1() {
    local -n data="${1}"
    # shellcheck disable=SC2178
    local -n cols="${2}"

    local -a t
    local i j
    for i in "${data[@]}"; do
        read -ra t <<< "${i}"
        for (( j = 0; j < ${#t[@]}; j++ )); do
            cols["${j}"]+="${t[j]},"
        done
    done
    cols=( "${cols[@]%,}" )
}

main() {
    local -a lines opers
    mapfile -t lines < "${1:-/dev/stdin}"
    # shellcheck disable=SC2034
    read -ra opers <<< "${lines[-1]}"
    unset 'lines[-1]'

    local -a cols1 cols2
    p1 "lines" "cols1"
    p2 "lines" "cols2"

    local i op prob p1 p2
    for (( i = 0; i < ${#opers[@]}; i++ )); do
        op="${opers[i]}"
        prob="${cols1[i]//,/${op}}"
        (( p1 += prob ))

        prob="${cols2[i]//,/${op}}"
        (( p2 += prob ))
    done

    printf '%d\n' "${p1}" "${p2}"
}

main "${@}"
