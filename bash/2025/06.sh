#!/usr/bin/env bash

# ref(lines), ref(opers)
p2() {
    local -n data="${1}"
    local -n ops="${2}"

    local i len
    for i in "${data[@]}"; do
        (( ${#i} > len )) && len="${#i}"
    done

    local -a cols
    local j c char csv slice
    for (( c = 0, i = 0; i < len; i++ )); do
        slice=""
        for j in "${data[@]}"; do
            char="${j:i:1}"
            slice+="${char:- }"
        done
        if [[ "${slice}" == *[[:digit:]]* ]]; then
            csv+="${slice},"
        else
            cols["${c}"]="${csv%,}"
            csv=""
            (( c++ ))
            continue
        fi
    done
    cols["${c}"]="${csv%,}"

    local op prob total
    for (( i = 0; i < ${#cols[@]}; i++ )); do
        op="${ops[i]}"
        prob="${cols[i]//,/${op}}"
        (( total += prob ))
    done

    printf '%d\n' "${total}"
}

# ref(lines), ref(opers)
p1() {
    local -n data="${1}"
    local -n ops="${2}"

    local -a cols t
    local i j
    for i in "${data[@]}"; do
        read -ra t <<< "${i}"
        for (( j = 0; j < ${#t[@]}; j++ )); do
            cols["${j}"]+="${t[j]},"
        done
    done
    cols=( "${cols[@]%,}" )

    # this is absolutely *wild* that it works
    local op prob total
    for (( i = 0; i < ${#cols[@]}; i++ )); do
        op="${ops[i]}"
        prob="${cols[i]//,/${op}}"
        (( total += prob ))
    done

    printf '%d\n' "${total:-0}"
}

main() {
    local -a lines opers
    mapfile -t lines < "${1:-/dev/stdin}"
    # shellcheck disable=SC2034
    read -ra opers <<< "${lines[-1]}"
    unset 'lines[-1]'

    p1 "lines" "opers"
    p2 "lines" "opers"
}

main "${@}"
