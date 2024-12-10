#!/usr/bin/env bash
# shellcheck disable=SC2178

# target total index ref(nums) [includeConcat]
check() {
    local -n nums="${4}"

    (( ${2} == ${1} && ${3} == ${#nums[@]} )) && return 0
    (( ${2} >  ${1} || ${3} == ${#nums[@]} )) && return 1

    check "${1}" "$(( ${2} + nums[${3}] ))" "$(( ${3} + 1 ))" "${@:4}" \
        && return 0
    check "${1}" "$(( ${2} * nums[${3}] ))" "$(( ${3} + 1 ))" "${@:4}" \
        && return 0

    (( ${5} == 1 )) \
        && check "${1}" "${2}${nums[${3}]}" "$(( ${3} + 1 ))" "${@:4}" \
        && return 0

    return 1
}

main() {
    local -a operands
    local line p1 p2

    while read -r line; do
        read -ra operands <<< "${line##*: }"
        if check "${line%:*}" "${operands[0]}" "1" "operands" "0"; then
            (( p1 += ${line%:*}, p2 += ${line%:*} ))
        elif check "${line%:*}" "${operands[0]}" "1" "operands" "1"; then
            (( p2 += ${line%:*} ))
        fi
    done < "${1:-/dev/stdin}"

    printf '%s\n' "${p1}" "${p2}"
}

main "${@}"
