#!/usr/bin/env bash

part_a() {
    local count digit
    count="0"

    while read -r digit; do
        case "${#digit}" in
            2 | 3 | 4 | 7 )     (( count++ ));;
        esac
    done < <(sed 's/^.*| //' "${1}" | tr " " '\n')

    printf '%s\n' "${count}"
}

part_b() {
    _get_digits() {
        local -a ds sl
        local idx

        mapfile -t sl < <(tr " " '\n' <<< "${1}")

        for idx in "${sl[@]}"; do
            case "${#idx}" in
                2 )     ds[1]="${idx}";;
                3 )     ds[7]="${idx}";;
                4 )     ds[4]="${idx}";;
                7 )     ds[8]="${idx}";;
            esac
        done

        # this is *real* horror
        while (( ${#ds[@]} < 10 )); do
            for idx in "${sl[@]}"; do
                case "${#idx}" in
                    6 )
                        if [[ -n "${ds[6]}" ]]; then
                            if [[ -n "${ds[0]}" ]]; then
                                if [[ "${idx}" != "${ds[6]}" && "${idx}" != "${ds[0]}" ]]; then
                                    ds[9]="${idx}"
                                fi
                            elif [[ "${idx}" != "${ds[6]}" ]]; then
                                if (( $(fold --width="1" <<< "${idx}" | grep --count "[${ds[4]}]") == 3 )); then
                                    ds[0]="${idx}"
                                fi
                            fi
                        elif (( $(fold --width="1" <<< "${idx}" | grep --count "[${ds[1]}]") == 1 )); then
                            ds[6]="${idx}"
                        fi
                        ;;
                    5 )
                        if [[ -n "${ds[5]}" ]]; then
                            if [[ -n "${ds[3]}" ]]; then
                                if [[ "${idx}" != "${ds[5]}" && "${idx}" != "${ds[3]}" ]]; then
                                    ds[2]="${idx}"
                                    break 2
                                fi
                            elif [[ -n "${ds[9]}" && "${idx}" != "${ds[5]}" ]]; then
                                if (( $(fold --width="1" <<< "${ds[9]}" | grep --count "[^${idx}]") == 1 )); then
                                    ds[3]="${idx}"
                                fi
                            elif [[ -n "${ds[6]}" ]]; then
                                if (( $(fold --width="1" <<< "${ds[6]}" | grep --count "[^${idx}]") == 1 )); then
                                    ds[5]="${idx}"
                                fi
                            fi
                        fi
                        ;;
                esac
            done
        done

        printf '%s\n' "${ds[@]}"
    }

    _filter() {
        local seq
        tr " " '\n' <<< "${*}" | while read -r seq; do
            fold --width="1" <<< "${seq}" | \
                sort | \
                paste --serial --delimiters='\0'
        done
    }

    local -a digits signals
    local line j k number sum

    while read -r line; do
        mapfile -t digits < <(_get_digits "$(_filter "${line/ | / }" | \
            awk '!seen[$0]++' | \
            paste --serial --delimiter=" " \
        )" )
        mapfile -t signals < <(_filter "$(sed 's/^.*| //' <<< "${line}")")
        unset number

        for j in "${signals[@]}"; do
            for (( k = 0; k < 10; k++ )); do
                if [[ "${digits[$k]}" == "${j}" ]]; then
                    number+="${k}"
                fi
            done
        done

        sum="$(bc <<< "${sum:-0} + ${number}")"
    done < "${1}"

    printf '%s\n' "${sum}"
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
