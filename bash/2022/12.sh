#!/usr/bin/env bash

parse() {
    local line j h char alpha

    alpha="abcdefghijklmnopqrstuvwxyz"
    width="$(head -1 "${1}" | wc --chars)"
    height="0"

    while read -r line; do
        (( height++ ))

        for (( j = 0; j < width; j++ )); do
            char="${line:$j:1}"

            case "${char}" in
                S )
                    startx="${j}"
                    starty="$(( height - 1 ))"
                    char="a"
                    ;;
                E )
                    endx="${j}"
                    endy="$(( height - 1 ))"
                    char="z"
                    ;;
            esac

            h="${alpha%${char}*}"
            map+=("${#h}")
        done
    done < "${1}"
}

part_a() {
    local -A visited
    local -a map x y s
    local width height startx starty endx endy j k

    parse "${1}"

    x=("${startx}")
    y=("${starty}")
    s=(0)

    for (( j = 0; j >= 0; j++ )); do
        k="$(( x[j] * width + x[j] ))"

        [[ -n "${visited[$j]}" ]] && continue
        visited["${j}"]="1"

        if (( x[j] == endx && y[j] == endy )); then
            printf '%d\n' "${s[$j]}"
            break
        fi

        if (( y[j] - 1 >= 0 )); then
            if (( map[(y[j] - 1) * width + x[j]] <= map[k] + 1 )); then
                x+=("${x[$j]}")
                y+=("$(( y[j] - 1 ))")
                s+=("$(( s[j] + 1 ))")
            fi
        fi

        if (( y[j] + 1 < height )); then
            if (( map[(y[j] + 1) * width + x[j]] <= map[k] + 1 )); then
                x+=("${x[$j]}")
                y+=("$(( y[j] + 1 ))")
                s+=("$(( s[j] + 1 ))")
            fi
        fi

        if (( x[j] - 1 >= 0 )); then
            if (( map[y[j] * width + (x[j] - 1)] <= map[k] + 1 )); then
                x+=("$(( x[j] - 1 ))")
                y+=("${y[$j]}")
                s+=("$(( s[j] + 1 ))")
            fi
        fi

        if (( x[j] + 1 < width )); then
            if (( map[y[j] * width + (x[j] + 1)] <= map[j] + 1 )); then
                x+=("$(( x[j] + 1 ))")
                y+=("${y[$j]}")
                s+=("$(( s[j] + 1 ))")
            fi
        fi
    done
}

part_b() {
    local -A visited
    local -a map x y s
    local width height startx starty endx endy j k

    parse "${1}"
    unset endx endy

    x=("${startx}")
    y=("${starty}")
    s=(0)

    for (( j = 0; j >= 0; j++ )); do
        k="$(( y[j] * width + x[j] ))"

        [[ -n "${visited[$j]}" ]] && continue
        visited["${j}"]="1"

        if (( map[k] == 0 )); then
            printf '%d\n' "${s[$j]}"
            break
        fi

        if (( y[j] - 1 >= 0 )); then
            if (( map[(y[j] - 1) * width + x[j]] >= map[k] - 1 )); then
                x+=("${x[$j]}")
                y+=("$(( y[j] - 1 ))")
                s+=("$(( s[j] + 1 ))")
            fi
        fi

        if (( y[j] + 1 < height )); then
            if (( map[(y[j] + 1) * width + x[j]] >= map[k] - 1 )); then
                x+=("${x[$j]}")
                y+=("$(( y[j] + 1 ))")
                s+=("$(( s[j] + 1 ))")
            fi
        fi

        if (( x[j] - 1 >= 0 )); then
            if (( map[y[j] * width + (x[j] - 1)] >= map[k] - 1 )); then
                x+=("$(( x[j] - 1 ))")
                y+=("${y[$j]}")
                s+=("$(( s[j] + 1 ))")
            fi
        fi

        if (( x[j] + 1 < width )); then
            if (( map[y[j] * width + (x[j] + 1)] >= map[k] - 1 )); then
                x+=("$(( x[j] + 1 ))")
                y+=("${y[$j]}")
                s+=("$(( s[j] + 1 ))")
            fi
        fi
    done
}

main() {
    set -- "${1:-/dev/stdin}"
    part_a "${1}"
    part_b "${1}"
}

main "${@}"
