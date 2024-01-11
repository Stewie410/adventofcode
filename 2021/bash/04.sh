#!/usr/bin/env bash
#
# 2021-12-04

part_a() {
    if ! command -v 'bc' &>/dev/null; then
        printf 'Missing required application: bc\n' >&2
        return 1
    fi

    _get_winning() {
        local k b e
        for (( k = 0; k < $(wc --lines < "${1}") / 5; k++ )); do
            b="$(( 1 + (k * 5) ))"
            e="$(( 5 + (k * 5) ))"

            sed --quiet "${b},${e}p" "${1}" | awk --assign "board=${k}" '
                /^(#\s){4}#$/ {
                    print board
                    exit 0
                }

                /#/ {
                    for (i = 1; i <= 5; i++)
                        if ($i == "#")
                            cols[i]++
                }

                END {
                    for (i = 1; i <= 5; i++) {
                        if (cols[i] == 5) {
                            print board
                            exit 0
                        }
                    }
                    exit 1
                }
            ' && return 0
        done
        return 1
    }

    _get_score() {
        local b e
        b="$(( 1 + (${1} * 5) ))"
        e="$(( 5 + (${1} * 5) ))"

        sed --quiet "${b},${e}p;s/#/0/g;s/ /+/g" "${2}" | \
            paste --serial --delimiter="+" | \
            bc
    }

    local -a numbers
    local boards score board j

    boards="$(mktemp)"
    mapfile -t numbers < <(head -1 "${1}" | tr "," '\n')
    sed '1,2d;s/^ /0/;s/  / 0/g;s/^\s*$/d' "${1}" > "${boards}"

    for j in "${numbers[@]}"; do
        (( ${#j} == 1 )) && j="0${j}"
        sed --in-place "s/${j}/#/g" "${boards}"
        board="$(_get_winning "${boards}")"
        if [[ -n "${board}" ]]; then
            score="$(_get_score "${board}" "${boards}")"
            sed --quiet "$(( 1 + (board * 5) )),$(( 5 + (board * 5) ))p" "${boards}" | column -t
            printf '%s: %s\n' \
                "Board" "${board}" \
                "Base" "${score}" \
                "Last" "${j}" \
                "Score" "$(( j * score ))"
        fi
    done

    rm --force "${boards}"
    (( score ))
}

part_b() {
    _is_winner() {
        local -a board
        local str x y

        mapfile -t board < <(tr " " '\n' < "${1}")
        for x in {0..4}; do
            [[ "${board[*]:$(( x * 5 )):5}" =~ (${2} ){4}${2} ]] && return 0
            for y in {0..4}; do
                str+="${board[$(( y * 5 + x ))]}"
            done
            [[ "${str}" =~ (${2}){5} ]] && return 0
            unset str
        done

        return 1
    }

    _get_base() {
        tr " " '+' <<< "${*}" | bc
    }

    local -a numbers boards
    local remaining mark j k

    mapfile -t numbers < <(head -1 "${1}" | tr "," '\n')
    mapfile -t boards < <(sed '1,2d;/^\s*$/d;s/^ /0/;s/  / 0/g' "${1}" | \
        paste --delimiters=" " - - - - - \
    )
    remaining="${#boards[@]}"
    mark="#"

    for j in "${numbers[@]}"; do
        (( ${#j} == 1 )) && j="0${j}"
        for (( k = 0; k < ${#boards[@]}; k++ )); do
            if [[ "${boards[$k]}" != "winner" ]]; then
                boards[${k}]="${boards[$k]//$j/$mark}"
                if _is_winner "${boards[$k]}" "${mark}"; then
                    if (( remaining == 1 )); then
                        tr " " '\n' <<< "${boards[$k]}" | \
                            paste --delimiters=" " - - - - - | \
                            column -t
                        printf '%s: %s\n' \
                            "Board" "${k}" \
                            "Base" "$(_get_base "${boards[$k]//$mark/0}")" \
                            "Last" "${j}" \
                            "Score" "$(( $(_get_base "${boards[$k]//$mark/0}") * j ))"
                        return 0
                    fi
                    boards[${k}]="winner"
                    (( remaining-- ))
                fi
            fi
        done
    done

    return 1
}
