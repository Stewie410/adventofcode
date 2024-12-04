#!/usr/bin/env bash

format_draws() {
    local arr
    read -ra arr <<< "${1//,/ }"
    printf '%02d\n' "${arr[@]}"
}

format_board() {
    while (( $# > 0 )); do
        [[ "${1:0:1}" == " " ]] && set -- "0${1# }" "${@:2}"
        printf '%s\n' "${1//  / 0}"
        shift
    done
}

is_winning() {
    local -a board
    local x y line diag

    set -- "${1//[0-9][0-9]/.}"
    set -- "${1// /}"
    IFS=$'\n' mapfile -t board <<< "${1}"

    # horizontal
    for y in "${board[@]}"; do
        [[ "${y}" == "xxxxx" ]] && return 0
    done

    # vertical & NW-SE diag
    unset diag
    for (( x = 0; x < 5; x++ )); do
        unset line
        diag+="${board[x]:x:1}"
        for (( y = 0; y < 5; y++ )); do
            line+="${board[y]:x:1}"
        done
        [[ "${line}" == "xxxxx" ]] && return 0
    done
    [[ "${diag}" == "xxxxx" ]] && return 0

    # NE-SW diag
    unset diag
    for (( y = 0; y < 5; y++ )); do
        for (( x = 4; x >= 0; x-- )); do
            diag+="${board[y]:x:1}"
        done
    done
    [[ "${diag}" == "xxxxx" ]] && return 9

    return 1
}

# board, mult
get_score() {
    local -a board nums
    local row num sum

    IFS=$'\n' mapfile -t board <<< "${1}"

    for row in "${board[@]}"; do
        read -ra nums <<< "${row}"
        for num in "${nums[@]}"; do
            case "${num:0:1}" in
                0 ) (( sum += ${num:1} ));;
                x ) (( sum += 0 ));;
                * ) (( sum += num ));;
            esac
        done
    done

    printf '%s\n' "$(( sum * $2 ))"
}

# slow, but works
main() {
    local -a data draws boards won
    local i j first last

    mapfile -t data < "${1:-/dev/stdin}"
    mapfile -t draws < <(format_draws "${data[0]}")

    for (( i = 1; i + 6 <= ${#data[@]}; i += 6 )); do
        boards+=( "$(format_board "${data[@]:i+1:5}")" )
    done

    for (( i = 0; i < ${#draws[@]} && ${#won[@]} < ${#boards[@]}; i++ )); do
        for (( j = 0; j < ${#boards[@]}; j++ )); do
            [[ -n "${won[j]}" ]] && continue

            boards[j]="${boards[j]//${draws[i]}/x}"
            is_winning "${boards[j]}" || continue
            won[j]="$(get_score "${boards[j]}" "${draws[i]}")"

            [[ -z "${first}" ]] && first="${won[j]}"
            last="${won[j]}"
        done
    done

    printf '%s\n' "${first}" "${last}"
}

main "${@}"
