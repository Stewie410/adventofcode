#!/usr/bin/env bash

part_a() {
    printf 'Not implemented\n' >&2
    return 1

    # local -A next
    # local -a paths
    # local line j k
    #
    # while read -r line; do
    #     [[ "${line%-*}" != "start" ]] && \
    #         next["${i##*-}"]+="${i%-*}"
    #     [[ "${line##*-}" != "start" ]] && \
    #         next["${i%-*}"]+="${i##*-}"
    # done < "${1}"
    #
    # for j in "${!next[@]}"; do
    #     printf '%s: %s\n' "${j}" "${next["$j"]}"
    # done
}

part_b() {
    printf 'Not implemented\n' >&2
    return 1
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
