#!/usr/bin/env bash

# this is slow and should be fixed, eventually
part_a() {
    local -a disk
    local i j k checksum

    for (( i = 0, k = 0; i < ${#1}; i++ )); do
        if (( i % 2 == 0 )); then
            for (( j = 0; j < ${1:i:1}; j++ )); do
                disk+=( "${k:=0}" )
            done
            (( k++ ))
        else
            for (( j = 0; j < ${1:i:1}; j++ )); do
                disk+=( "-1" )
            done
        fi
    done

    for (( i = ${1:0:1}, j = ${#disk[@]} - 1; i != j; )); do
        if (( disk[i] >= 0 )); then
            (( i++ ))
            continue
        elif (( disk[j] < 0 )); then
            (( j-- ))
            continue
        fi

        disk[i]="${disk[j]}"
        disk[j]="."
        (( i++, j-- ))
    done

    for (( i = 0; i < ${#disk[@]}; i++ )); do
        [[ "${disk[i]}" == "." ]] && break
        (( checksum += i * disk[i] ))
    done

    printf '%s\n' "${checksum:-0}"
}

part_b() {
    local -a files empty disk
    local i j k l fdx flen edx elen checksum

    for (( i = 0; i < ${#1}; i++ )); do
        if (( i % 2 == 0 )); then
            files+=( "${#disk[@]}:${1:i:1}" )
            for (( j = 0, k = ${#files[@]} - 1; j < ${1:i:1}; j++ )); do
                disk+=( "${k}" )
            done
        else
            empty+=( "${#disk[@]}:${1:i:1}" )
            for (( j = 0; j < ${1:i:1}; j++ )); do
                disk+=( "-1" )
            done
        fi
    done

    for (( i = ${#files[@]} - 1; i > 0; i-- )); do
        IFS=':' read -r fdx flen <<< "${files[i]}"
        for (( j = 0; j < ${#empty[@]}; j++ )); do
            IFS=':' read -r edx elen <<< "${empty[j]}"
            (( edx < fdx )) || break
            (( edx > 0 && elen >= flen )) || continue

            for (( k = edx, l = fdx; k < (edx + flen); k++, l++ )); do
                (( disk[k] = i, disk[l] = -1, elen-- ))
            done

            (( edx = elen > 0 ? edx + flen : -1 ))
            empty[j]="${edx}:${elen}"
            break
        done
    done

    for (( i = 0; i < ${#disk[@]}; i++ )); do
        (( disk[i] >= 0 )) || continue
        (( checksum += i * disk[i] ))
    done

    printf '%s\n' "${checksum}"
}

main() {
    local raw
    read -r raw < "${1:-/dev/stdin}"
    part_a "${raw}"
    part_b "${raw}"
}

main "${@}"
