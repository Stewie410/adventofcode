#!/usr/bin/env bash

get_most_common() {
    local all one zero
    all="$(cut --characters="${1}" "${2}" | paste --serial --delimiters='\0')"
    zero="${all//1/}"
    one="${all//0/}"

    (( ${#one} > ${#zero} )) && return 1
    return 0
}

get_len() {
    head -1 "${1}" | wc --chars
}

part_a() {
    local gamma epsilon len j

    len="$(get_len "${1}")"

    for (( j = 1; j <= len; j++ )); do
        if get_most_common "${j}" "${1}"; then
            gamma+="0"
            epsilon+="1"
        else
            gamma+="1"
            epsilon+="0"
        fi
    done

    printf '%s\n' "$(( (2#${gamma}) * (2#${epsilon}) ))"
}

part_b() {
    local gen scrub init bit tmp j
    tmp="$(mktemp)"

    init="$(get_most_common 1 "${1}")"
    bit="${init}"
    sed --quiet "/^${bit}/p" "${1}" > "${tmp}"
    for (( j = 2; $(wc --lines < "${tmp}") > 1; j++ )); do
        bit="$(get_most_common "${j}" "${tmp}")"
        sed --in-place --quiet "/^[0-9]\{$(( j - 1 ))\}${bit}/p" "${tmp}"
    done
    read -r gen < "${tmp}"

    bit="${init}"
    sed --quiet "/^$(( 1 - bit ))/p" "${1}" > "${tmp}"
    for (( j = 2; $(wc --lines < "${tmp}"); j++ )); do
        bit="$(get_most_common "${j}" "${tmp}")"
        sed --in-place --quiet "/^[0-9]\{$(( j - 1 ))\}$(( 1 - bit ))/p" "${tmp}"
    done
    read -r scrub < "${tmp}"

    rm --force "${tmp}"
    printf '%s\n' "$(( (2#${gen}) * (2#${scrub}) ))"
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
