#!/usr/bin/env bash

solution() {
    part_a "${1}"
    on_ranges "${1}"
}

part_a() {
    local -a maps
    local j line src dst len least

    j="-1"

    while read -r line; do
        case "${line}" in
            seeds:* )       local -a "seeds=(${line##*: })";;
            *map:* )        (( j++ ));;
            [[:digit:]]* )  maps["${j}"]+="${line},"
        esac
    done < "${1}"

    for (( j = 0; j < ${#seeds[@]}; j++ )); do
        for k in "${maps[@]}"; do
            while read -r dst src len; do
                if (( seeds[j] >= src && seeds[j] < src + len )); then
                    (( seeds[j] += dst - src ))
                    break
                fi
            done < <(tr "," '\n' <<< "${k}")
        done
    done

    least="${seeds[0]}"
    for j in "${seeds[@]}"; do
        (( least = j < least ? j : least ))
    done
    printf '%d\n' "${least}"
}

# couldn't write something entirely on my own, so based my solution
# *heavily* on:
# https://www.reddit.com/r/adventofcode/comments/18b4b0r/2023_day_5_solutions/kcbv9j1/
on_ranges() {
    _seeds() {
        tr " " '\n' <<< "${1##*: }" | \
            paste --delimiters=" " - - | \
            awk '{ print $1, $1 + $2 - 1 }'
    }

    _mapping() {
        awk '{ print $2, $2 + $3 - 1, $1 - $2 }' <<< "${1}"
    }

    _lowest() {
        printf '%s\n' "${@}" | \
            cut --fields="1" --delimiter=" " | \
            sort --numeric-sort | \
            sed '1q'
    }

    local -a seeds maps starts ends
    local j line seed map x1 x2 y1 y2 diff broke lowest least

    least="$(( (1 << 63) - 1 ))"
    j="-1"

    while read -r line; do
        case "${line}" in
            seeds:* )       mapfile -t seeds < <(_seeds "${line}");;
            *map:* )        (( j++ ));;
            [[:digit:]]* )  maps["${j}"]+="$(_mapping "${line}"),";;
        esac
    done < "${1}"

    for seed in "${seeds[@]}"; do
        ends=("${seed}")
        for map in "${maps[@]}"; do
            starts=("${ends[@]}")
            unset ends
            while (( ${#starts[@]} )); do
                x1="${starts[-1]% *}"; x2="${starts[-1]##* }"
                unset 'starts[-1]' broke

                while read -r y1 y2 diff; do
                    if (( x1 >= y1 && x2 <= y2 )); then
                        ends+=("$(( x1 + diff )) $(( x2 + diff ))")
                        broke="1"
                        break
                    fi
                    (( x2 < y1 || x1 > y2 )) && continue
                    if (( x1 < y1 )); then
                        starts+=("${x1} $(( y1 - 1 ))")
                        starts+=("${y1} ${x2}")
                        broke="1"
                        break
                    fi
                    if (( x2 > y2 )); then
                        starts+=("${x1} ${y2}")
                        starts+=("$(( y2 + 1 )) ${x2}")
                        broke="1"
                        break
                    fi
                done < <(tr "," '\n' <<< "${map%,*}")
                [[ -z "${broke}" ]] && ends+=("${x1} ${x2}")
            done
        done
        lowest="$(_lowest "${ends[@]}")"
        (( least = lowest < least ? lowest : least ))
    done

    printf '%d\n' "${least}"
}

# My original solution as "reverse" brute force
# Running this takes at least 4 days if not longer, given its single-threaded
# Leaving this in-place for one commit for posterity
rev_brute_force() {
    local -a maps seeds
    local j k line loc src dst len

    while read -r line; do
        if [[ "${line}" =~ ^seeds: ]]; then
            mapfile -t seeds < <(tr " " '\n' <<< "${line##*: }" | \
                paste --delimiters=" " - - | \
                awk '{ print $1, $1 + $2 - 1 }' \
            )
        elif [[ "${line}" =~ map:\s*$ ]]; then
            j="$(( ${j:=-1} + 1 ))"
        elif [[ "${line}" =~ ^[0-9] ]]; then
            maps["${j}"]+="${line},"
        fi
    done < "${1}"

    mapfile -t seeds < <(printf '%s\n' "${seeds[@]}" | sort --numeric-sort)

    for (( j = 0, loc = j; ; j++, loc = j )); do
        for (( k = ${#maps[@]} - 1; k >= 0; k-- )); do
            while read -r dst src len; do
                if (( loc >= dst && loc <= dst + len - 1 )); then
                    (( loc = loc - dst + src ))
                    break
                fi
            done < <(tr "," '\n' <<< "${maps[k]}")
        done

        while read -r src dst; do
            if (( loc >= src && loc <= dst )); then
                printf '%d\n' "${j}"
                break 2
            fi
        done < <(printf '%s\n' "${seeds[@]}")
    done
}
