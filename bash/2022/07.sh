#!/usr/bin/env bash

parse() {
    local line j

    while read -r line; do
        if [[ "${line}" == "\$ cd"* ]]; then
            j="${line##* }"
            case "${j}" in
                '..' )      (( ${#path} > 1 )) && path="${path%/*}";;
                '/' )       path='/';;
                * )
                    [[ "${path: -1}" != '/' ]] && path+="/"
                    path+="${j}"
                    ;;
            esac
        elif [[ "${line}" == "\$ ls"* ]]; then
            dirs["${path}"]="0"
        elif [[ "${line}" == [[:digit:]]* ]]; then
            (( dirs["${path}"] += ${line%% *} ))
        fi
    done < "${1}"
}

part_a() {
    local -A dirs sizes
    local j k path total

    parse "${1}"

    for j in "${!dirs[@]}"; do
        for k in "${!dirs[@]}"; do
            [[ "${k}" == "${j}"* ]] && \
                (( sizes["$j"] += dirs["$j"] ))
        done
        (( sizes["${j}"] <= 100000 )) && \
            (( total += sizes["${j}"] ))
    done

    printf '\nTotal: %s\n' "${total}"
}

part_b() {
    local -A dirs sizes
    local j k path cdir capacity

    parse "${1}"

    for j in "${!dirs[@]}"; do
        for k in "${!dirs[@]}"; do
            [[ "${k}" == "${j}"* ]] && \
                (( sizes["$j"] += dirs["${j}"] ))
        done
    done

    capacity="$(( 70000000 - sizes['/'] ))"

    for j in "${!sizes[@]}"; do
        if (( capacity + sizes["$j"] >= 30000000 )); then
            if [[ -z "${cdir}" ]] || (( sizes["$j"] < sizes["$cdir"] )); then
                cdir="${j}"
            fi
        fi
    done

    printf '%s: %s\n' "${cdir}" "${sizes["$cdir"]}"
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
