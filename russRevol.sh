#!/bin/bash

#fancy colors kek
fail="\033[31;1m"
info="\033[1;36m"
NC="\033[0m"

validation() {
    local blt=$1

    if ! [[ $bullets =~ ^[0-6]+$ ]]
    then
        printf "$fail The bullets count aren't a letters, use numbers dummy $NC\n"
    elif [ $bullets -gt 6 ] || [ $bullets -lt 1 ]
    then
        printf "$fail Specife range from: 1-6 bullets $NC\n"
    else
        printf "There are: $info${blt}$NC bullets in chamber, good luck!\n"
    fi

}

random_remove(){
    #choose random 0-5
    mapfile -t indeksy < <(shuf -i 0-5 -n "$bullets")

    #Insert bullets in chamber
    for B_load in "${indeksy[@]}"
    do
        chamber[$B_load]="${fail}X${NC}"
    done

    #printf "%b\n" "${chamber[*]}"
}

spin(){
    local X=4
    local chamber_size=${#chamber[@]}
    local arraytwo=()

    for ((i=0; i<chamber_size; i++)); do
        arraytwo[$(( (i + X) % chamber_size ))]="${chamber[$i]}"
    done

    chamber=("${arraytwo[@]}")

    #printf "%b\n" "${chamber[*]}"
}


new_game(){
    tput clear
    chamber=(0 0 0 0 0 0)
    random_remove
}

decisionMaker(){
    while true; do
        printf "[P]ull trigger or [S]pin?: " > /dev/tty
        read -r action

        action_upper=${action^^}  #Always Upper letter 
        
        case "$action_upper" in
            P|S)
                echo "$action_upper"
                return 0
                ;;
            *)
                echo "invalid option" > /dev/tty
                ;;
        esac
    done
}

shoot(){
    #value iteration 
    for iterate in "${chamber[@]}"; do
            decision_upper=$(decisionMaker)

            if [[ "${decision_upper}" == "P" ]]; then
            tput clear
                case $iterate in
                    "${fail}X${NC}" )
                        #printf "%b\n" "${chamber[*]}"
                        play revolverShoot.mp3 &> /dev/null
                        printf "\nClick*, BOOM..... you just died!\n\n"
                        while true; do
                            echo "Game over"
                            printf "\nPlay Again?\n [Y]es, [N]o: "
                            read -r again
                            
                            againU=${again^^}
                                if [[ "$againU" == "Y" ]]; then
                                    return 0
                                elif [[ "$againU" == "N" ]]; then
                                    return 1
                                
                                else
                                    echo "invalid option!"
                                fi
                        done
                        ;;
                    "0" )
                        play revolerClickEmpty.mp3 &> /dev/null
                        printf "\nClick, Uff...empty\n"
                        
                        ;;
                    esac
            elif [[ "$decision_upper" == "S" ]]; then
                play revolverSpin.mp3 &> /dev/null
                spin
                return 0
            fi
    done
}

echo "-Welcome to Russian_Roullete v1 writen in bash-"

echo -n "Provide amounts of bullets: "  
read -r bullets  


validation
new_game

#fruit loop kek (game loop) 
while true; do
    shoot
    status=$?
    if [[ $status -eq 1 ]]; then
        break
    fi

    new_game
done




### DEBUG ###
#printf '\n[RND Num table: Indeksy]: \n'
#for a in "${indeksy[@]}"
#do
#    echo "$a" 
#done

#echo "How many is in list: ${#chamber[@]}"

