#!/usr/bin/env bash
#
# Bash AOC Solution runner

show_help() {
    cat << EOF
Bash AOC Solution runner

USAGE: ${0##*/} [OPTIONS] DAY FILE

OPTIONS:
    -h, --help          Show this help message
    -Y, --year YYYY     Specify a specific year's solution, rather than current
    -a, --part-a        Only get first result
    -b, --part-b        Only get second result
EOF
}

main() {
    local opts year date only file
    year="$(date '+%Y')"
    opts="$(getopt \
        --options hY:ab \
        --longoptions help,year:,part-a,part-b \
        --name "${0##*/}" \
        -- "${@}" \
    )"

    eval set -- "${opts}"
    while true; do
        case "${1}" in
            -h | --help )       show_help; return 0;;
            -Y | --year )       year="${2}"; shift;;
            -a | --part-a )     only="a";;
            -b | --part-b )     only="b";;
            -- )                shift; break;;
            * )                 break;;
        esac
        shift
    done

    if [[ -z "${2}" ]]; then
        printf 'No input file specified\n' >&2
        return 1
    elif [[ -z "${1}" || "${1}" =~ ^[^0-9]+$ ]]; then
        printf 'No day specified\n' >&2
        return 1
    fi

    date="${1}"
    [[ "${#date}" == 1 ]] && date="0${date}"
    file="$(realpath "${2/\~/$HOME}")" || return 1

    if ! [[ -d "${0%/*}/${year}/bash" ]]; then
        printf 'No solution(s) for year: %s\n' "${year}" >&2
        return 1
    elif ! [[ -s "${0%/*}/${year}/bash/${date}.sh" ]]; then
        printf 'No solution for date: %s-%s\n' "${year}" "${date}" >&2
        return 1
    fi

    # shellcheck disable=SC1090
    source "${0%/*}/${year}/bash/${date}.sh"

    case "${only}" in
        a )
            if declare -F 'part_a' &>/dev/null; then
                part_a "${file}"
            else
                solution "${file}" | head -1
            fi
            ;;
        b )
            if declare -F 'part_b' &>/dev/null; then
                part_b "${file}"
            else
                solution "${file}" | tail -1
            fi
            ;;
        * )
            solution "${file}"
            ;;
    esac
}

main "${@}"
