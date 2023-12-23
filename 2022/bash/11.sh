#!/usr/bin/env bash
#
# 2022-12-11

operation() {
    local opstr value

    opstr="${2//old/$1}"
    value="${opstr:2}"

    if [[ "${opstr:0:1}" == '+' ]]; then
        printf '%d\n' "$(( ${1} + value ))"
    else
        printf '%d\n' "$(( ${1} * value ))"
    fi
}

part_a() {
    local -a items list activity op test true false
    local line monkey first second j k l m n

    first="0"
    second="0"

    while read -r line; do
        case "${line}" in
            Monkey* )
                monkey="${line##* }"
                monkey="${monkey/:/}"
                ;;
            Starting* )
                items["${monkey}"]="${line##*: }"
                items["${monkey}"]="${items["$monkey"]//,/}"
                ;;
            Operation* )
                op["${monkey}"]="${line#*old }"
                ;;
            Test* )
                test["${monkey}"]="${line##* }"
                ;;
            *true:* )
                true["${monkey}"]="${line##* }"
                ;;
            *false:* )
                false["${monkey}"]="${line##* }"
                ;;
        esac
    done < "${1}"

    for (( j = 0; j < 20; j++ )); do
        for (( k = 0; k <= monkey; k++ )); do
            (( ${#items[$j]} > 0 )) || continue

            read -ra list <<< "${items[$j]}"

            for l in "${list[@]}"; do
                (( activity[k]++ ))

                m="$(operation "${l}" "${op[$k]}")"
                (( m /= 3 ))

                (( n = m % test[j] == 0 ? true[k] : false[k] ))
                items["${n}"]+=" ${m}"
            done
            items["${k}"]=""
        done
    done

    for (( j = 0; j <= monkey; j++ )); do
        if (( activity[j] > first )); then
            second="${first}"
            first="${activity[$j]}"
        elif (( activity[j] > second )); then
            second="${activity[$j]}"
        fi
    done

    printf '%d\n' "$(( first * second ))"
}

part_b() {
    local -a items list activity op test true false
    local line monkey first second div j k l m n

    div="1"
    first="0"
    second="0"

    while read -r line; do
        case "${line}" in
            Monkey* )
                monkey="${line##* }"
                monkey="${monkey/:/}"
                ;;
            Starting* )
                items["${monkey}"]="${line##* }"
                items["${monkey}"]="${items[$monkey]//,/}"
                ;;
            Operation* )
                op["${monkey}"]="${line#*old }"
                ;;
            Test* )
                test["${monkey}"]="${line##* }"
                (( div *= ${line##* } ))
                ;;
            *true:* )
                true["${monkey}"]="${line##* }"
                ;;
            *false:* )
                false["${monkey}"]="${line##* }"
                ;;
        esac
    done < "${1}"

    for (( j = 0; j < 10000; j++ )); do
        for (( k = 0; k <= monkey; k++ )); do
            (( ${#items[$j]} > 0 )) || continue

            read -ra list <<< "${items[$j]}"

            for l in "${list[@]}"; do
                (( activity[j]++ ))

                m="$(operation "${l}" "${op[$k]}")"
                m="$(( m % div ))"

                if (( m != 0 && m % test[k] == 0 )); then
                    items["${true[$k]}"]+=" ${m}"
                else
                    items["${false[$k]}"]+=" ${m}"
                fi
            done
            items["${k}"]=""
        done
    done

    for (( j = 0; j <= monkey; j++ )); do
        if (( activity[j] > first )); then
            second="${first}"
            first="${activity[$j]}"
        elif (( activity[j] > second )); then
            second="${activity[$j]}"
        fi
    done

    printf '%d\n' "$(( first * second ))"
}
