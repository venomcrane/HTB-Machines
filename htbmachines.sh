#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
# Extra Colors
cyanColour="\e[0;96m\033[1m"       # Cian brillante
orangeColour="\e[38;5;214m\033[1m"  # Naranja
pinkColour="\e[38;5;205m\033[1m"    # Rosa fuerte
lightRedColour="\e[1;91m\033[1m"    # Rojo claro
lightGreenColour="\e[1;92m\033[1m"  # Verde claro
lightYellowColour="\e[1;93m\033[1m" # Amarillo claro
lightBlueColour="\e[1;94m\033[1m"   # Azul claro
lightPurpleColour="\e[1;95m\033[1m" # Púrpura claro
lightCyanColour="\e[1;96m\033[1m"   # Cian claro
whiteColour="\e[1;97m\033[1m"       # Blanco brillante
blackColour="\e[1;90m\033[1m"       # Negro grisáceo
goldColour="\e[38;5;220m\033[1m"    # Dorado
silverColour="\e[38;5;250m\033[1m"  # Plateado
bronzeColour="\e[38;5;130m\033[1m"  # Bronce






#Variables globales 
main_url="https://htbmachines.github.io/bundle.js"


#Ctrl+C 
function ctrl_c(){
  echo -e "\n\n${redColour}[+] Leaving...${endColour}\n"
  exit 1
}

trap ctrl_c INT


banner="${greenColour}$(cat << "EOF"

    __  ____________     __  ______   ________  _______   _____________
   / / / /_  __/ __ )   /  |/  /   | / ____/ / / /  _/ | / / ____/ ___/
  / /_/ / / / / __  |  / /|_/ / /| |/ /   / /_/ // //  |/ / __/  \__ \ 
 / __  / / / / /_/ /  / /  / / ___ / /___/ __  // // /|  / /___ ___/ / 
/_/ /_/ /_/ /_____/  /_/  /_/_/  |_\____/_/ /_/___/_/ |_/_____//____/  [v 1.0]
                               
                                     -=[ by r4venn ]=-                                        


EOF
)${endColour}"


function helpPanel(){
  
  echo -e "$banner"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Usage:${endColour} \n\t./htbmachines.sh [options] [arguments]"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Options:${endColour}"
  echo -e "\t-d                 -Install dependencies"
  echo -e "\t-u                 -Download or update required files"
  echo -e "\t-a                 -Show all IP Addresses and Machines (Interactive)"
  echo -e "\t-i <ip_address>    -Search by IP Address"
  echo -e "\t-m <machineName>   -Search Machine Name"
  echo -e "\t-s                 -Search Machines by Difficulty (Interactive)"
  echo -e "\t-h                 -Help Panel"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Examples:${endColour}"
  echo -e "\t./htbmachines.sh -m Inception"
  echo -e "\t./htbmachines.sh -i 10.10.10.248"
  }


#Instala las dependencias
function installDependencies(){
  echo -e "\n[+] Installing dependencies (requires sudo)..."
  sleep 2
  sudo apt install moreutils && sudo apt install nodejs npm && sudo npm install -g js-beautify 
  echo -e "\n⭐ All dependencies installed" 
}

#animacion
function spinner(){
  local SPIN=("◐" "◓" "◑" "◒")
  local i=0 
  while true; do 
    echo -ne "\r[${SPIN[i]}] $1"
    ((i=(i+1)%4))
    sleep 0.1
  done
}


# Función para actualizar archivos
function updateFiles(){
  echo -e "${blueColour}[!] Make sure you have installed the dependencies with -i parameter ${endColour}"
  sleep 1

  if [ ! -f bundle.js ]; then
    echo "[+] HTB Database required"
    sleep 1
    spinner "Downloading Hack The Box Machines Database..." &  # Spinner en segundo plano
  else
    echo "[+] HTB Database Update"
    sleep 1
    spinner "Updating Hack The Box Machines Database..." &  # Spinner en segundo plano
  fi

  SPIN_PID=$!
  curl -s "$main_url" > bundle.js
  js-beautify bundle.js | sponge bundle.js
  kill $SPIN_PID && wait $SPIN_PID 2>/dev/null
  
  # Limpiar línea y mostrar mensaje final
  echo -ne "\r\033[K⭐ Operation completed! - 201 Machines here\n"
} 

#Buscador
function searchMachine() {
  machineName="$1"
  

  # Verificar si la base de datos está presente
  if [ ! -f bundle.js ]; then
    echo -e "${redColour}[!] Database not found. Run ./htbmachines.sh -u to update.${endColour}"
    exit 1 
  fi

  output_machines="$(grep "name: " bundle.js | tail -n 201 | sed 's/name/Machine/' | tr -d '"' | tr -d ",")"

  if [[ $output_machines == *$machineName* ]]; then

    echo -e "${cyanColour}---------------------------------------------------------------------------------------------${endColour}"
    echo -e "[+] ${yellowColour}Machine Information:${endColour} ${turquoiseColour}$machineName${endColour}"
    echo -e "${cyanColour}---------------------------------------------------------------------------------------------${endColour}"

    cat bundle.js | awk -v mname="$machineName" '$0 ~ "name: \"" mname "\"" , /resuelta:/' \
    | grep -vE "id:|sku| resuelta" \
    | tr -d '"' | tr -d ',' \
    | sed "s/name:/$(echo -e "${grayColour}Name:${endColour} ${greenColour}")/" \
    | sed "s/ip:/$(echo -e "${grayColour}IP:${endColour} ${greenColour}")/" \
    | sed "s/so:/$(echo -e "${grayColour}OS:${endColour} ${greenColour}")/" \
    | sed "s/Media/$(echo -e "${grayColour}Medium${endColour} ${greenColour}")/" \
    | sed "s/Fácil/$(echo -e "${grayColour}Easy${endColour} ${greenColour}")/" \
    | sed "s/Difícil/$(echo -e "${grayColour}Hard${endColour} ${greenColour}")/" \
    | sed "s/dificultad:/$(echo -e "${grayColour}Difficulty:${endColour} ${greenColour}")/" \
    | sed "s/like:/$(echo -e "${grayColour}Certifications Prep:${endColour} ${greenColour}")/" \
    | sed "s/skills:/$(echo -e "${grayColour}Skills:${endColour} ${greenColour}")/" \
    | sed "s/Youtube:/$(echo -e "${grayColour}Youtube:${endColour} ${greenColour}")/" \
    | sed "s/^ *//" \
    | sed -E '/^skills:/ s/: /:\n\t[+] /' \
    | sed -E 's/ - /\n\t[+] /g' \
    | sed -E 's/^(.)/\U\1/'
    echo -e "${cyanColour}---------------------------------------------------------------------------------------------${endColour}"
  elif [[ $output_machines != *$machineName* ]]; then  
    echo -e "\n${redColour}[!] The Machine is not here, sorry${endColour}"
  fi 
}

#Muestra todas la maquinas o todas las direcciones IP
function show_all(){
  echo -e "$banner"

  echo -e "\n${cyanColour}--------------------------------[::] Select an option [::]--------------------------------${endColour}\n\n"
  echo -e "${greenColour}[ 1 ]${endColour}${yellowColour} Show all Machine Names${endColour} "
  echo -e "${greenColour}[ 2 ]${endColour}${yellowColour} Show all IP Addresses${endColour}\n\n "

  echo -ne "${purpleColour}[~]${endColour} ${grayColour}Select: ${endColour}"
  read output_show

  if [[ $output_show -eq 1 ]]; then

    echo -e "\n${greenColour}[+]${endColour} ${blueColour}Showing all Machine names...${endColour}"
    sleep 1
    grep "name: " bundle.js | tail -n 201 | sed "s/name: /$(echo -e "${blueColour}Machine:${endColour} ${greenColour}") /" | tr -d '"' | tr -d "," | column



  elif [[ $output_show -eq 2 ]]; then
 
    echo -e "\n${greenColour}[+]${endColour} ${blueColour}Showing all IP Addresses...${endColour}"
    sleep 1
    grep "ip: " bundle.js | tr -d " "  | sed "s/ip:/$(echo -e "${blueColour}IP${endColour} - ${greenColour}")/" | tr -d ',' | tr -d '"' | tail -n 201 | column 
  else 
    echo -e "${redColour}\n[!] You have to select 1 or 2${endColour}"
    exit 1
  fi

}

function search_ip(){
  ip_address=$1 
  
  machineName="$(cat bundle.js| grep "ip: \"$ip_address\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ",")"

  echo -e "${cyanColour}---------------------------------------------------------------------------------------------${endColour}"
  echo -e "[+] IP Address: ${turquoiseColour}$ip_address${endColour} \n[+] Machine: ${turquoiseColour}$machineName${endColour}"

  searchMachine $machineName
  
}


function search_difficulty(){
  echo -e "$banner"
  echo -e "\n${cyanColour}--------------------------------[::] Select an option [::]--------------------------------${endColour}\n\n"
  echo -e "\n${greenColour}[+] Search by:${endColour}\n"
  echo -e "${greenColour}[ 1 ]${endColour}${yellowColour} Easy Machines${endColour} "
  echo -e "${greenColour}[ 2 ]${endColour}${yellowColour} Medium Machines${endColour} "
  echo -e "${greenColour}[ 3 ]${endColour}${yellowColour} Hard Machines${endColour} "
  echo -e "${greenColour}[ 4 ]${endColour}${yellowColour} Insane${endColour} "

  echo -ne "\n\n${purpleColour}[~]${endColour} ${grayColour}Select:${endColour} "
  read output_show



  if [[ $output_show -eq 1 ]]; then
    cat bundle.js | grep "Fácil" -A 2 -B 5 \
    | grep -vE "id:|sku|resuelta|push|Css|Color:|Case|Return|Switch" \
    | tr -d '"' | tr -d ',' | tr -d '-' \
    | sed "s/name:/$(echo -e "${grayColour}Name:${endColour} ${greenColour}")/" \
    | sed "s/ip:/$(echo -e "${grayColour}IP:${endColour} ${greenColour}")/" \
    | sed "s/so:/$(echo -e "${grayColour}OS:${endColour} ${greenColour}")/" \
    | sed "s/Fácil/$(echo -e "${grayColour}Easy${endColour} ${greenColour}")/" \
    | sed "s/dificultad:/$(echo -e "${grayColour}Difficulty:${endColour} ${greenColour}")/" \
    | sed "s/like:/$(echo -e "${grayColour}Certifications Prep:${endColour} ${greenColour}")/" \
    | sed "s/skills:/$(echo -e "${grayColour}Skills:${endColour} ${greenColour}")/" \
    | sed "s/Youtube:/$(echo -e "${grayColour}Youtube:${endColour} ${greenColour}")/" \
    | sed "s/^ *//" \
    | sed -E '/^skills:/ s/: /:\n\t[+] /' \
    | sed -E 's/ - /\n\t[+] /g' \
    | sed -E 's/^(.)/\U\1/' \
    | awk -v line="$(echo -e "${cyanColour}--------------------------------[::] Easy [::]--------------------------------${endColour}")" '{print} /Certifications Prep:/ {print "\n" line "\n"}'
  elif [[ $output_show -eq 2 ]]; then 
    cat bundle.js | grep "Media" -A 2 -B 5 \
    | grep -vE "id:|sku|resuelta|push|Css|Color:|Case|Return|Switch" \
    | tr -d '"' | tr -d ',' | tr -d '-' \
    | sed "s/name:/$(echo -e "${grayColour}Name:${endColour} ${greenColour}")/" \
    | sed "s/ip:/$(echo -e "${grayColour}IP:${endColour} ${greenColour}")/" \
    | sed "s/so:/$(echo -e "${grayColour}OS:${endColour} ${greenColour}")/" \
    | sed "s/Media/$(echo -e "${blueColour}Medium${endColour} ${greenColour}")/" \
    | sed "s/dificultad:/$(echo -e "${grayColour}Difficulty:${endColour} ${greenColour}")/" \
    | sed "s/like:/$(echo -e "${grayColour}Certifications Prep:${endColour} ${greenColour}")/" \
    | sed "s/skills:/$(echo -e "${grayColour}Skills:${endColour} ${greenColour}")/" \
    | sed "s/Youtube:/$(echo -e "${grayColour}Youtube:${endColour} ${greenColour}")/" \
    | sed "s/^ *//" \
    | sed -E '/^skills:/ s/: /:\n\t[+] /' \
    | sed -E 's/ - /\n\t[+] /g' \
    | sed -E 's/^(.)/\U\1/' \
    | awk -v line="$(echo -e "${cyanColour}--------------------------------[::] Medium [::]--------------------------------${endColour}")" '{print} /Certifications Prep:/ {print "\n" line "\n"}'

  elif [[ $output_show -eq 3 ]]; then 
    cat bundle.js | grep "Difícil" -A 2 -B 5 \
    | grep -vE "id:|sku|resuelta|push|Css|Color:|Case|Return|Switch" \
    | tr -d '"' | tr -d ',' | tr -d '-' \
    | sed "s/name:/$(echo -e "${grayColour}Name:${endColour} ${greenColour}")/" \
    | sed "s/ip:/$(echo -e "${grayColour}IP:${endColour} ${greenColour}")/" \
    | sed "s/so:/$(echo -e "${grayColour}OS:${endColour} ${greenColour}")/" \
    | sed "s/Difícil/$(echo -e "${blueColour}Hard${endColour} ${greenColour}")/" \
    | sed "s/dificultad:/$(echo -e "${grayColour}Difficulty:${endColour} ${greenColour}")/" \
    | sed "s/like:/$(echo -e "${grayColour}Certifications Prep:${endColour} ${greenColour}")/" \
    | sed "s/skills:/$(echo -e "${grayColour}Skills:${endColour} ${greenColour}")/" \
    | sed "s/Youtube:/$(echo -e "${grayColour}Youtube:${endColour} ${greenColour}")/" \
    | sed "s/^ *//" \
    | sed -E '/^skills:/ s/: /:\n\t[+] /' \
    | sed -E 's/ - /\n\t[+] /g' \
    | sed -E 's/^(.)/\U\1/' \
    | awk -v line="$(echo -e "${cyanColour}--------------------------------[::] Medium [::]--------------------------------${endColour}")" '{print} /Certifications Prep:/ {print "\n" line "\n"}'

  elif [[ $output_show -eq 4 ]]; then 
    cat bundle.js | grep "Insane" -A 2 -B 5 \
    | grep -vE "id:|sku|resuelta|push|Css|Color:|Case|Return|Switch" \
    | tr -d '"' | tr -d ',' | tr -d '-' \
    | sed "s/name:/$(echo -e "${grayColour}Name:${endColour} ${greenColour}")/" \
    | sed "s/ip:/$(echo -e "${grayColour}IP:${endColour} ${greenColour}")/" \
    | sed "s/so:/$(echo -e "${grayColour}OS:${endColour} ${greenColour}")/" \
    | sed "s/Insane/$(echo -e "${blueColour}Insane${endColour} ${greenColour}")/" \
    | sed "s/dificultad:/$(echo -e "${grayColour}Difficulty:${endColour} ${greenColour}")/" \
    | sed "s/like:/$(echo -e "${grayColour}Certifications Prep:${endColour} ${greenColour}")/" \
    | sed "s/skills:/$(echo -e "${grayColour}Skills:${endColour} ${greenColour}")/" \
    | sed "s/Youtube:/$(echo -e "${grayColour}Youtube:${endColour} ${greenColour}")/" \
    | sed "s/^ *//" \
    | sed -E '/^skills:/ s/: /:\n\t[+] /' \
    | sed -E 's/ - /\n\t[+] /g' \
    | sed -E 's/^(.)/\U\1/' \
    | awk -v line="$(echo -e "${cyanColour}--------------------------------[::] Medium [::]--------------------------------${endColour}")" '{print} /Certifications Prep:/ {print "\n" line "\n"}'

  fi 

}

#Indicadores
declare -i parameter_counter=0

while getopts "m:udi:ash" arg; do
  case $arg in 

    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    d) let parameter_counter+=3;;
    i) ip_address=$OPTARG; let parameter_counter+=4;;
    a) let parameter_counter+=5;;
    s) let parameter_counter+=6;;
    h) ;;
  esac
done


if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  installDependencies
elif [ $parameter_counter -eq 4 ]; then 
  search_ip $ip_address
elif [ $parameter_counter -eq 5 ]; then 
  show_all
elif [ $parameter_counter -eq 6 ]; then 
  search_difficulty
else
  helpPanel 
fi

