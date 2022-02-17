#!/bin/bash

while read line
    do 
        lines+=($line)
done < $1

line1=(${lines[1]} ${lines[2]} ${lines[3]} ${lines[4]} ${lines[5]})
line2=(${lines[6]} ${lines[7]} ${lines[8]} ${lines[9]} ${lines[10]})
line3=(${lines[11]} ${lines[12]} ${lines[13]}'m' ${lines[14]} ${lines[15]})
line4=(${lines[16]} ${lines[17]} ${lines[18]} ${lines[19]} ${lines[20]})
line5=(${lines[21]} ${lines[22]} ${lines[23]} ${lines[24]} ${lines[25]})

nums_array=(${line1[*]} ${line2[*]} ${line3[*]} ${line4[*]} ${line5[*]})

line3start=(${lines[11]} ${lines[12]} ${lines[13]} ${lines[14]} ${lines[15]})

input="$(< $1)"
seed=`echo "${input}" | head -1`
start_array=(${line1[*]} ${line2[*]} ${line3start[*]} ${line4[*]} ${line5[*]})
RANDOM=$seed 

col1start=(${start_array[0]} ${start_array[5]} ${start_array[10]} ${start_array[15]} ${start_array[20]})
col2start=(${start_array[1]} ${start_array[6]} ${start_array[11]} ${start_array[16]} ${start_array[21]})
col3start=(${start_array[2]} ${start_array[7]} ${start_array[12]} ${start_array[17]} ${start_array[22]})
col4start=(${start_array[3]} ${start_array[8]} ${start_array[13]} ${start_array[18]} ${start_array[23]})
col5start=(${start_array[4]} ${start_array[9]} ${start_array[14]} ${start_array[19]} ${start_array[24]})


col_one_ints=(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15)
col_two_ints=(16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)
col_three_ints=(31 32 33 34 35 36 37 38 39 40 41 42 43 44 45)
col_four_ints=(46 47 48 49 50 51 52 53 54 55 56 57 58 59 60)
col_five_ints=(61 62 63 64 65 66 67 68 69 70 71 72 73 74 75)



#FUNCTIONS


function update_array () {
    local array
    array=("$@")

    unset array[0]

    index=-1

    for i in "${!array[@]}";
    do
        if [[ "${array[$i]}" = ${1} ]];
        then  
            index=$i
            break
        fi
    done
    array[$index]=$1'm'

    echo ${array[@]}

}



function print_array () {
    local array
    array=("$@")

    echo "L       I       N       U       X"
    col1=(${array[0]} ${array[5]} ${array[10]} ${array[15]} ${array[20]})
    col2=(${array[1]} ${array[6]} ${array[11]} ${array[16]} ${array[21]})
    col3=(${array[2]} ${array[7]} ${array[12]} ${array[17]} ${array[22]})
    col4=(${array[3]} ${array[8]} ${array[13]} ${array[18]} ${array[23]})
    col5=(${array[4]} ${array[9]} ${array[14]} ${array[19]} ${array[24]})

    paste <(printf "%s\n" ${col1[@]}) <(printf "%s\n"  ${col2[@]}) <(printf "%s\n"  "${col3[@]}") <(printf "%s\n"  "${col4[@]}") <(printf "%s\n"  "${col5[@]}")
}


function array_dupe_check () {
    return_flag=false
    have_seen_before=()
    local array
    array=("$@")
    for i in "${array[@]}"; do
        i=$((10#$1))
        if [ -z "${have_seen_before[i]}" ]; then
            have_seen_before[i]=1
        else
            return_flag=true
            break
        fi
    done
    echo $return_flag      
}


function error_check () {

    if [ ! -r $1 -a -e $1 ]  
    then
        echo "input file missing or unreadable" >/dev/stderr
        exit 1
    elif [ ! `wc -l < $1` \= 6 ]
    then 
        echo "input file must have 6 lines" >/dev/stderr
        exit 2
    elif [[ ! $seed =~ ^[0-9]*$ ]]
    then 
        echo "seed line format error" >/dev/stderr
        exit 3
    elif [[ ${start_array[*]} =~ [A-Za-z] ]]
    then
        echo "card format error" >/dev/stderr
        exit 4
    elif [[ ${#start_array[*]} < 25 ]]
    then
        echo "card format error" >/dev/stderr
        exit 4
    fi
}

function call_list () {

    if [[ ${col_one_ints[*]} =~ $1 ]]; then
        call_array+=("L"$1)
    elif [[ ${col_two_ints[*]} =~ $1 ]]; then
        call_array+=("I"$1)
    elif [[ ${col_three_ints[*]} =~ $1 ]]; then
        call_array+=("N"$1)
    elif [[ ${col_four_ints[*]} =~ $1 ]]; then
        call_array+=("U"$1)
    elif [[ ${col_five_ints[*]} =~ $1 ]]; then
        call_array+=("X"$1)
    fi
            
            
    echo "CALL LIST: " ${call_array[*]}
    
        
}




function bingo_check () {
    local array
    array=("$@")
    localreturn_flag=false
    for i in ${array[*]}
        do
            if [[ ${array[0]} =~ "m" && ${array[4]} =~ "m" && ${array[20]} =~ "m" && ${array[24]} =~ "m" ]]                          #corner check
            then
                return_flag=true
            elif [[ ${array[0]} =~ "m" && ${array[5]} =~ "m" && ${array[10]} =~ "m" && ${array[15]} =~ "m" && ${array[20]} =~ "m" ]]      #column 1 check
            then
                return_flag=true
            elif [[ ${array[1]} =~ "m" && ${array[6]} =~ "m" && ${array[11]} =~ "m" && ${array[16]} =~ "m" && ${array[21]} =~ "m" ]]      #column 2 check
            then
                return_flag=true
            elif [[ ${array[2]} =~ "m" && ${array[7]} =~ "m" && ${array[17]} =~ "m" && ${array[22]} =~ "m" ]]                        #column 3 check
            then
                return_flag=true
            elif [[ ${array[3]} =~ "m" && ${array[8]} =~ "m" && ${array[13]} =~ "m" && ${array[18]} =~ "m" && ${array[23]} =~ "m" ]]      #column 4 check
            then
                return_flag=true
            elif [[ ${array[4]} =~ "m" && ${array[9]} =~ "m" && ${array[14]} =~ "m" && ${array[19]} =~ "m" && ${array[24]} =~ "m" ]]      #column 5 check
            then
                return_flag=true
            elif [[ ${array[0]} =~ "m" && ${array[1]} =~ "m" && ${array[2]} =~ "m" && ${array[3]} =~ "m" && ${array[4]} =~ "m" ]]         #row 1 check
            then
                return_flag=true
            elif [[ ${array[5]} =~ "m" && ${array[6]} =~ "m" && ${array[7]} =~ "m" && ${array[8]} =~ "m" && ${array[9]} =~ "m" ]]         #row 2 check
            then
                return_flag=true
            elif [[ ${array[10]} =~ "m" && ${array[11]} =~ "m" && ${array[13]} =~ "m" && ${array[14]} =~ "m" ]]                      #row 3 check
            then
                return_flag=true
            elif [[ ${array[15]} =~ "m" && ${array[16]} =~ "m" && ${array[17]} =~ "m" && ${array[18]} =~ "m" && ${array[19]} =~ "m" ]]    #row 4 check
            then
                return_flag=true
            elif [[ ${array[20]} =~ "m" && ${array[21]} =~ "m" && ${array[22]} =~ "m" && ${array[23]} =~ "m" && ${array[24]} =~ "m" ]]    #row 5 check
            then
                return_flag=true
            else
                return_flag=false
            fi
    done
    echo $return_flag
    
}




#RUNNING THE PROGRAM

declare -a random_calls
flag=false
while [ $flag = false ]  
    do
        error_check $1
        read -n1 -p "enter any key to get a call or q to quit: " answer
        if [ $answer != "q" ]
        then
            call=$((1 + $RANDOM % 75))
            echo ""
            if [[ $call = '1' || $call = '2' || $call = '3' || $call = '4' || $call = '5' || $call = '6' || $call = '7' || $call = "8" || $call = '9' ]];
            then
               call='0'$call
            fi

            while [[ ${random_calls[*]} =~ $call ]] 
            do
                call=$((1 + $RANDOM % 75))
            done
            random_calls+=($call)
            echo ""


            call_list $call

            for i in ${nums_array[*]}
                do 

                    if [ $i = $call ]
                    then 

                        nums_array=$(update_array $i ${nums_array[@]})           
                        print_array ${nums_array[@]} 

                        break
                    fi      

            done
            flag=$(bingo_check ${nums_array[@]})
        else  
            break
        fi  
done

if [ $flag = true ]
then 
echo "WINNER"
fi
