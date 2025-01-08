#!/usr/bin/env bash

# this is ugly, but I'm not sure how to really improve
#
# ref(map) ref(bot) direction width height
step() {
    local -n arr="${1}"
    local -n pos="${2}"
    local -a box queue copy
    local i j k w h x y xq yq d newpos
    (( d = ${3}, w = ${4}, h = ${5} ))
    (( y = pos / w, x = pos % w ))

    if (( d % 2 == 0 )); then
        (( xq = 0, yq = d == 0 ? -1 : 1 ))
        (( newpos = (y + yq) * w + x ))
        queue=( "${pos}" )
        while (( ${#queue[@]} > 0 )); do
            copy=()
            for i in "${queue[@]}"; do
                (( y = i / w, x = i % w ))
                (( j = (y + yq) * w + x ))
                (( arr[i] == 4 )) && return 1
                (( arr[i] == 0 )) && continue
                copy+=( "${j}" )
                case "${arr[i]}" in
                    1 ) (( box[i]++ ));;
                    2 )
                        copy+=( "$(( j + 1 ))" )
                        (( box[i]++, box[i + 1]++ ))
                        ;;
                    3 )
                        copy+=( "$(( j - 1 ))" )
                        (( box[i - 1]++, box[i]++ ))
                        ;;
                esac
            done
            queue=( "${copy[@]}" )
        done

        if (( ${#box[@]} > 0 )); then
            # map -> int[] && reverse
            mapfile -t queue < <(printf '%d\n' "${!box[@]}")
            box=()
            for (( i = ${#queue[@]} - 1; i >= 0; i-- )); do
                box+=( "${queue[i]}" )
            done

            (( i = d == 0 ? ${#box[@]} - 1 : 0 ))
            for (( ; i >= 0 && i < ${#box[@]}; i += yq )); do
                (( y = box[i] / w, x = box[i] % w ))
                (( arr[(y + yq) * w + x] = arr[y * w + x] ))
                (( arr[y * w + x] = 0 ))
            done
        fi
    else
        (( yq = 0, xq = d == 1 ? 1 : -1 ))
        (( newpos = y * w + (x + xq) ))
        for (( i = x + xq; i >= 0 && i < w; i += xq )); do
            (( arr[y * w + i] == 4 )) && return 1
            box+=( "$(( y * w + i ))" )
            (( arr[y * w + i] == 0 )) && break
        done

        for (( i = ${#box[@]} - 1; i > 0 && i < w; i-- )); do
            (( j = box[i], k = box[i - 1] ))
            (( arr[j] = arr[k] ))
        done
    fi

    (( arr[pos] = 0, arr[newpos] = 5, pos = newpos ))
    return 0
}

# ref(map) width
gps() {
    local -n arr="${1}"
    local i x y w sum
    (( w = ${2} ))

    for i in "${!arr[@]}"; do
        (( arr[i] == 1 || arr[i] == 2 )) || continue
        (( y = i / w, x = i % w ))
        (( sum += 100 * y + x ))
    done

    printf '%d\n' "${sum:-0}"
}

main() {
    local -a map1 map2 moves
    local x y w1 w2 h m bot1 bot2 line

    while read -r line; do
        (( ${#line} == 0 )) && continue
        if [[ "${line:0:1}" == "#" ]]; then
            (( w1 = ${#line}, w2 = ${#line} * 2, h++ ))
            for (( x = 0; x < w1; x++ )); do
                case "${line:x:1}" in
                    "." )   map1+=( 0 ); map2+=( 0 0 );;
                    "O" )   map1+=( 1 ); map2+=( 2 3 );;
                    "#" )   map1+=( 4 ); map2+=( 4 4 );;
                    "@" )
                        (( bot1 = ${#map1[@]}, bot2 = ${#map2[@]} ))
                        map1+=( 5 )
                        map2+=( 5 0 )
                        ;;
                esac
            done
        else
            for (( x = 0; x < ${#line}; x++ )); do
                case "${line:x:1}" in
                    "^" )   moves+=( 0 );;
                    ">" )   moves+=( 1 );;
                    "v" )   moves+=( 2 );;
                    "<" )   moves+=( 3 );;
                esac
            done
        fi
    done < "${1:-/dev/stdin}"

    for m in "${moves[@]}"; do
        step "map1" "bot1" "${m}" "${w1}" "${h}"
        step "map2" "bot2" "${m}" "${w2}" "${h}"
    done

    gps "map1" "${w1}"
    gps "map2" "${w2}"
}

main "${@}"
