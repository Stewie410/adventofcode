#!/usr/bin/env bash

part_a() {
    _get_adjacents() {
        (( x + 1 > width )) && \
            printf '%s\n' "${map[$(( y * width + (x + 1) ))]}"
        (( x - 1 >= 0 )) && \
            printf '%s\n' "${map[$(( y * width + (x - 1) ))]}"
        (( y + 1 < height )) && \
            printf '%s\n' "${map[$(( (y + 1) * width + x ))]}"
        (( y - 1 >= 0 )) && \
            printf '%s\n' "${map[$(( (y - 1) * width + x ))]}"
    }

    local -a map
    local width height sum x y

    width="$(head -1 "${1}" | wc --chars)"
    height="$(wc --lines < "${1}")"
    mapfile -t map < <(fold --width="1" "${1}")
    sum="0"

    for (( y = 0; y < height; y++ )); do
        for (( x = 0; x < width; x++ )); do
            if (( map[y * width + x] < $(_get_adjacents | sort --numeric-sort | head -1) )); then
                (( sum += map[y * width + x] + 1 ))
            fi
        done
    done

    printf '%s\n' "${sum}"
}

part_b() {
    _get_group() {
        local _x _y

        _x="${1}"
        _y="${2}"

        (( _y < 0 || _y >= height || _x < 0 || _x >= width )) && return
        (( map[_y * width + _x] == 9 || map[_y * width + _x] == -1 )) && return
        map["$(( _y * width + _x ))"]="-1"
        (( groups[${#groups[@]} - 1]++ ))

        _get_group "$(( _x + 1 ))" "${_y}"
        _get_group "$(( _x - 1 ))" "${_y}"
        _get_group "${_x}" "$(( _y + 1 ))"
        _get_group "${_x}" "$(( _y - 1 ))"
    }

    local -a map groups
    local width height x y

    width="$(head -1 "${1}" | wc --chars)"
    height="$(wc --lines < "${1}")"
    mapfile -t map < <(fold --width="1" "${1}")

    for (( y = 0; y < height; y++ )); do
        for (( x = 0; x < width; x++ )); do
            groups+=(0)
            _get_group "${x}" "${y}"
        done
    done

    printf '%s\n' "${groups[@]}" | \
        sort --numeric-sort --reverse | \
        head -3 | \
        paste --serial --delimiter="*" | \
        bc
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
