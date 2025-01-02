#!/usr/bin/env bash
#
# Thanks to u/c4irns for the explainer on tree-detection...its a lot cleaner
# than my original check.
#
# https://old.reddit.com/r/adventofcode/comments/1hdvhvu/2024_day_14_solutions/m2ck0kh/

# ref(position/out) ref(velocity) width height [count=1]
step() {
    local -n bot="${1}"
    local -n amt="${2}"
    local i px py vx vy w h count
    (( w = ${3}, h = ${4}, count = ${5:-1} ))

    for (( i = 0; i < ${#bot[@]}; i++ )); do
        read -r px py vx vy <<< "${bot[i]} ${amt[i]}"
        (( px = (px + vx * count) % w, py = (py + vy * count) % h ))
        (( px += px < 0 ? w : 0, py += py < 0 ? h : 0 ))
        bot[i]="${px} ${py}"
    done
}

# ref(position) width height
get_score() {
    local -n arr="${1}"
    local -a quad
    local i x y mw mh
    (( mw = ${2} / 2, mh = ${3} / 2 ))

    for i in "${arr[@]}"; do
        read -r x y <<< "${i}"
        (( y == mh || x == mw )) && continue
        (( quad[(y > mh) * 2 + (x > mw)]++ ))
    done

    printf '%d\n' "$(( quad[0] * quad[1] * quad[2] * quad[3] ))"
}

# ref(position) width
only_unique() {
    local -n arr="${1}"
    local -a seen
    local i x y w
    (( w = ${2} ))

    for i in "${arr[@]}"; do
        read -r x y <<< "${i}"
        (( seen[y * w + x]++ ))
        (( seen[y * w + x] > 1 )) && return 1
    done

    return 0
}

main() {
    local -a pos vel seen
    local i w h x y v t line part

    while read -r line; do
        part="${line//[pv=]/}"
        read -r x y v <<< "${part//,/ }"
        (( w = x > w ? x : w, h = y > h ? y : h ))
        pos+=( "${x} ${y}" )
        vel+=( "${v}" )
    done < "${1:-/dev/stdin}"
    (( w++, h++ ))

    # part_b is unique to real data; so we'll skip if just testing
    if (( w == 11 && h == 7 )); then
        step "pos" "vel" "${w}" "${h}" "100"
        get_score "pos" "${w}" "${h}"
        return
    fi

    for (( t = 0; t >= 0; t++ )); do
        (( t == 100 )) && get_score "pos" "${w}" "${h}"
        only_unique "pos" "${w}" && break
        step "pos" "vel" "${w}" "${h}"
    done

    printf '%d\n' "${t}"
}

main "${@}"
