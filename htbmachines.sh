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
                               
                                     -=[ by r4venn_ ]=-                                        


EOF
)${endColour}"




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
  echo -e "${blueColour}[!] Make sure you have installed the dependencies with -d parameter ${endColour}"
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
  echo -e "\n${greenColour}[+] Show all:${endColour}\n"
  echo -e "${greenColour}[ 1 ]${endColour}${yellowColour} Machine Names${endColour} "
  echo -e "${greenColour}[ 2 ]${endColour}${yellowColour} IP Addresses${endColour} "
  echo -e "${greenColour}[ 3 ]${endColour}${yellowColour} Easy ${endColour} "
  echo -e "${greenColour}[ 4 ]${endColour}${yellowColour} Medium${endColour} "
  echo -e "${greenColour}[ 5 ]${endColour}${yellowColour} Hard${endColour}"
  echo -e "${greenColour}[ 6 ]${endColour}${yellowColour} Insane${endColour}"
  echo -e "${greenColour}[ 7 ]${endColour}${yellowColour} Linux Machines${endColour} "
  echo -e "${greenColour}[ 8 ]${endColour}${yellowColour} Windows Machines${endColour}\n\n "

  echo -ne "${purpleColour}[~]${endColour} ${grayColour}Select: ${endColour}"
  read output_show

  if [[ $output_show -eq 1 ]]; then
    echo -e "${cyanColour}\n--------------------------------------------[::] All Machines [::]--------------------------------------------------\n${endColour}"
    cat bundle.js| grep "dificultad: "  -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d "," | column 
    echo -e "${cyanColour}\n--------------------------------------------[::] All Machines [::]--------------------------------------------------\n${endColour}"
  elif [[ $output_show -eq 2 ]]; then
    echo -e "${cyanColour}\n--------------------------------------------[::] IP [::]--------------------------------------------------\n${endColour}"
    grep "ip: " bundle.js | tr -d " "  | sed "s/ip:/$(echo -e "> ")/" | tr -d ',' | tr -d '"' | tail -n 201 | column
    echo -e "${cyanColour}\n--------------------------------------------[::] IP [::]--------------------------------------------------\n${endColour}"
  elif [[ $output_show -eq 3 ]]; then 
    echo -e "${cyanColour}\n--------------------------------------------[::] Easy [::]--------------------------------------------------\n${endColour}"
    cat bundle.js| grep "dificultad: \"Fácil\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d "," | column 
    echo -e "${cyanColour}\n--------------------------------------------[::] Easy [::]--------------------------------------------------\n${endColour}"
  elif [[ $output_show -eq 4 ]]; then 

    echo -e "${cyanColour}\n--------------------------------------------[::] Medium [::]--------------------------------------------------\n${endColour}"
    cat bundle.js| grep "dificultad: \"Media\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d "," | column 
    echo -e "${cyanColour}\n--------------------------------------------[::] Medium [::]--------------------------------------------------\n${endColour}"

  elif [[ $output_show -eq 5 ]]; then 

    echo -e "${cyanColour}\n--------------------------------------------[::] Hard [::]--------------------------------------------------\n${endColour}"
    cat bundle.js| grep "dificultad: \"Difícil\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d "," | column 
    echo -e "${cyanColour}\n--------------------------------------------[::] Hard [::]--------------------------------------------------\n${endColour}"

  elif [[ $output_show -eq 6 ]]; then
    
    echo -e "${cyanColour}\n--------------------------------------------[::] Insane [::]--------------------------------------------------\n${endColour}"
    cat bundle.js| grep "dificultad: \"Insane\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d "," | column 
    echo -e "${cyanColour}\n--------------------------------------------[::] Insane [::]--------------------------------------------------\n${endColour}"

  elif [[ $output_show -eq 7 ]]; then
    echo -e "${cyanColour}\n--------------------------------------------[::] Linux [::]--------------------------------------------------\n${endColour}"
    cat bundle.js| grep "Linux" -B 4 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d "," | column
    echo -e "${cyanColour}\n--------------------------------------------[::] Linux [::]--------------------------------------------------\n${endColour}"

  elif [[ $output_show -eq 8  ]]; then 
    echo -e "${cyanColour}\n--------------------------------------------[::] Windows [::]--------------------------------------------------\n${endColour}"
    cat bundle.js| grep "Windows" -B 4 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d "," | column
    echo -e "${cyanColour}\n--------------------------------------------[::] Windows [::]--------------------------------------------------\n${endColour}"
    

 
  else 
    echo -e "${redColour}\n[!] You have to select a number [1-8]${endColour}"
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


function search_skill(){
  skill="$1"
  
  check_skill="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d "," | column)"

  if [ "$check_skill" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${greenColour}Machines with skills of${endColour}${blueColour} $skill ${endColour}"
    echo -e "${cyanColour}\n--------------------------------------------[::] Machines [::]--------------------------------------------------\n${endColour}"
    cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d "," | column
    echo -e "${cyanColour}\n--------------------------------------------[::] Machines [::]--------------------------------------------------\n${endColour}"
  else
    echo -e "\n${redColour}[!] Not found${endColour} \n"
  fi 

  }

function helpPanel(){
  
  echo -e "$banner"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Usage:${endColour} \n\t./htbmachines.sh [options] [arguments]"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Options:${endColour}"
  echo -e "\t-d                 -Install dependencies"
  echo -e "\t-u                 -Download or update required files"
  echo -e "\t-a                 -Show all [Interactive]"
  echo -e "\t-i <ip_address>    -Search by IP Address"
  echo -e "\t-m <machineName>   -Search Machine Name"
  echo -e "\t-s <skill>         -Search by Skill"
  echo -e "\t-h                 -Help Panel"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Examples:${endColour}"
  echo -e "\t./htbmachines.sh -m Inception"
  echo -e "\t./htbmachines.sh -i 10.10.10.248"
  echo -e "\t./htbmachines.sh -s SSRF" 
  echo -e '\t./htbmachines.sh -s "Local File Inclusion"'
  }


#Indicadores
declare -i parameter_counter=0


while getopts "m:udi:as:h" arg; do
  case $arg in 

    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    d) let parameter_counter+=3;;
    i) ip_address=$OPTARG; let parameter_counter+=4;;
    a) let parameter_counter+=5;;
    s) skill="$OPTARG"; let parameter_counter+=6;;
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
  search_skill "$skill" 

else
  helpPanel 
fi

