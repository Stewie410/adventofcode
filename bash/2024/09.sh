#!/usr/bin/env bash

# part_a
# ref(disk)
bit_fill() {
    local -n out="${1}"
    local i j

    for (( i = 0, j = ${#out[@]} - 1; i < j; )); do
        if (( out[i] >= 0 || out[j] < 0 )); then
            (( i += out[i] >= 0 ? 1 : 0 ))
            (( j -= out[j] < 0 ? -1 : 0 ))
            continue
        fi
        (( disk[i] = disk[j], disk[j] = -1, i++, j-- ))
    done
}

# part_b
# ref(disk) ref(files) ref(empty)
block_fill() {
    local -n out="${1}"
    local -n f="${2}"
    local -n e="${3}"
    local i j k l fdx flen edx elen

    for (( i = ${#f[@]} - 1; i > 0; i-- )); do
        IFS=':' read -r fdx flen <<< "${f[i]}"
        for (( j = 0; j < ${#e[@]}; j++ )); do
            IFS=':' read -r edx elen <<< "${e[j]}"
            (( edx < fdx )) || break
            (( edx > 0 && elen >= flen )) || continue
            for (( k = edx, l = fdx; k < (edx + flen); k++, l++ )); do
                (( disk[k] = i, disk[l] = -1, elen-- ))
            done
            (( edx = elen > 0 ? edx + flen : -1 ))
            e[j]="${edx}:${elen}"
            break
        done
    done
}

main() {
    local -a files empty da db
    local i j k sum_a sum_b

    read -r i < "${1:-/dev/stdin}"
    set -- "${i}"

    for (( i = 0; i < ${#1}; i += 2 )); do
        files+=( "${#da[@]}:${1:i:1}" )
        for (( j = 0; j < ${1:i:1}; j++ )); do
            da+=( "${k:=0}" )
        done
        (( k++ ))
        (( i + 1 > ${#1} )) || continue
        empty+=( "${#da[@]}:${1:i+1:1}" )
        for (( j = 0; j < ${1:i+1:1}; j++ )); do
            da+=( "-1" )
        done
    done
    db=( "${da[@]}" )

    bit_fill "da"
    block_fill "files" "empty" "db"

    for (( i = 0; i < ${#da[@]}; i++ )); do
        (( sum_a += da[i] >= 0 ? i * da[i] : 0 ))
        (( sum_b += db[i] >= 0 ? i * db[i] : 0 ))
    done

    printf '%s\n' "${sum_a:-0}" "${sum_b:-0}"
}

main "${@}"
