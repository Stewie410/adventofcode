#!/usr/bin/env bash
#
# 2022-12-08

part_a() {
    _up() {
        local j
        for (( j = y - 1; j >= 0; j-- )); do
            (( trees[y * width + x] <= trees[j * width + x] )) && \
                return 1
        done
        return 0
    }

    _down() {
        local j
        for (( j = y + 1; j < height; j++ )); do
            (( trees[y * width + x] <= trees[j * width + x] )) && \
                return 1
        done
        return 0
    }

    _left() {
        local j
        for (( j = x - 1; j >= 0; j-- )); do
            (( trees[y * width + x] <= trees[y * width + j] )) && \
                return 1
        done
        return 0
    }

    _right() {
        local j
        for (( j = x + 1; j < width; j++ )); do
            (( trees[y * width + x] > trees[y * width + j] )) && \
                return 1
        done
        return 0
    }

    local -a trees
    local visible width height x y

    mapfile -t trees < <(fold --width="1" "${1}")
    width="$(head -1 "${1}" | wc --chars)"
    height="$(wc --lines < "${1}")"
    visible="$(( 2 * (width - 2 + height) ))"

    for (( y = 1; y < height - 1; y++ )); do
        for (( x = 1; x < width - 1; x++ )); do
           if _up || _down || _left || _right; then
               (( visible++ ))
            fi
        done
    done

    printf '%s\n' "${visible}"
}

part_b() {
    local -a trees
    local width height max score coords x y j u d l r

    mapfile -t trees < <(fold --width="1" "${1}")
    width="$(head -1 "${1}" | wc --chars)"
    height="$(wc --lines < "${1}")"
    max="0"

    for (( y = 1; y < height - 1; y++ )); do
        for (( x = 1; x < width - 1; x++ )); do
            u="0"; d="0"; l="0"; r="0"

            for (( j = y - 1; j >= 0; j-- )); do
                (( u++ ))
                (( trees[j * width + x] >= trees[y * width + x] )) && \
                    break
            done

            for (( j = y + 1; j < height; j++ )); do
                (( d++ ))
                (( trees[j * width + x] >= trees[y * width + x] )) && \
                    break
            done

            for (( j = x - 1; j >= 0; j-- )); do
                (( l++ ))
                (( trees[y * width + j] >= trees[y * width + x] )) && \
                    break
            done

            for (( j = x + 1; j < width; j++ )); do
                (( r++ ))
                (( trees[y * width + j] >= trees[y * width + x] )) && \
                    break
            done

            score="$(( u * d * l * r ))"

            if (( score > max )); then
                max="${score}"
                coords="${x},${y}"
            fi
        done
    done

    printf '[%s] %s\n' "${coords}" "${max}"
}
