#!/bin/bash/
# Surge Panel Installation Wrapper
# Currently Supported Operating Systems:
#   Ubuntu

LOG_FILE="./logs/Surge-Panel.log"

loading() {
    width=120
    num_hashes=$((width - 10))
    echo -n "Loading: ["
    for ((i=0; i<=num_hashes; i++)); do
        sleep 0.1
        percent=$(( (i * 100) / num_hashes ))
        printf "\rLoading: [%-${num_hashes}s] ${percent}%%" "$(printf '#%.0s' $(seq 1 $i))"
    done
    echo "] Done!"
}
countdown() {
    echo "Starting in:"
    for i in {3..1}; do
        echo "$i..."
        sleep 1
    done
    echo "Starting"
}
count_down() {
    echo "Starting in:"
    for i in {30..1}; do
        echo "$i..."
        sleep 1
    done
    echo "Starting"
}

echo "------------------------------------------Surge Panel Installation Wrapper----------------------------------------------------"
echo ""
echo "          _____                    _____                    _____                    _____                    _____           "
echo "         /\    \                  /\    \                  /\    \                  /\    \                  /\    \          "
echo "        /::\    \                /::\____\                /::\    \                /::\    \                /::\    \         "
echo "       /::::\    \              /:::/    /               /::::\    \              /::::\    \              /::::\    \        "
echo "      /::::::\    \            /:::/    /               /::::::\    \            /::::::\    \            /::::::\    \       "
echo "     /:::/\:::\    \          /:::/    /               /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \      "
echo "    /:::/__\:::\    \        /:::/    /               /:::/__\:::\    \        /:::/  \:::\    \        /:::/__\:::\    \     "
echo "    \:::\   \:::\    \      /:::/    /               /::::\   \:::\    \      /:::/    \:::\    \      /::::\   \:::\    \    "
echo "  ___\:::\   \:::\    \    /:::/    /      _____    /::::::\   \:::\    \    /:::/    / \:::\    \    /::::::\   \:::\    \   "
echo " /\   \:::\   \:::\    \  /:::/____/      /\    \  /:::/\:::\   \:::\____\  /:::/    /   \:::\ ___\  /:::/\:::\   \:::\    \  "
echo "/::\   \:::\   \:::\____\!:::!    /      /::\____\/:::/  \:::\   \:::!    !/:::/____/  ___\:::!    !/:::/__\:::\   \:::\____\ "
echo "\:::\   \:::\   \::/    /!:::!____\     /:::/    /\::/   !::::\  /:::!____!\:::\    \ /\  /:::!____!\:::\   \:::\   \::/    / "
echo " \:::\   \:::\   \/____/  \:::\    \   /:::/    /  \/____!:::::\/:::/    /  \:::\    /::\ \::/    /  \:::\   \:::\   \/____/  "
echo "  \:::\   \:::\    \       \:::\    \ /:::/    /         !:::::::::/    /    \:::\   \:::\ \/____/    \:::\   \:::\    \      "
echo "   \:::\   \:::\____\       \:::\    /:::/    /          !:::\::::/    /      \:::\   \:::\____\       \:::\   \:::\____\     "
echo "    \:::\  /:::/    /        \:::\__/:::/    /           !::! \::/____/        \:::\  /:::/    /        \:::\   \::/    /     "
echo "     \:::\/:::/    /          \::::::::/    /            !::!  ~!               \:::\/:::/    /          \:::\   \/____/      "
echo "      \::::::/    /            \::::::/    /             !::!   !                \::::::/    /            \:::\    \          "
echo "       \::::/    /              \::::/    /              !::!   !                 \::::/    /              \:::\____\         "
echo "        \::/    /                \::/    /                !:!   !                  \::/    /                \::/    /         "
echo "         \/____/                  \/____/                  !!___!                   \/____/                  \/____/          "
loading

# Am I root? With Prompt
if [ "$(id -u)" != "0" ]; then
    echo 'This script is recommended to be run as root.'
    read -p 'Do you want to attempt to install without root privileges? (y/n): ' choice
    case "$choice" in
        y|Y ) 
            echo 'Continuing without root privileges...' | tee -a $LOG_FILE
            read -sp 'Please enter your password for sudo access: ' user_password
            echo
            echo "$user_password" | sudo -S -v
            if [ $? -ne 0 ]; then
                echo 'Error: Enable use of sudo to run. Terminating.' | tee -a $LOG_FILE
                exit 0
            fi
            ;;
        n|N ) 
            echo 'Error: this script can only be executed by root' | tee -a $LOG_FILE
            exit 1
            ;;
        * ) 
            echo 'Invalid choice. Exiting.' | tee -a $LOG_FILE
            exit 1
            ;;
    esac
fi

if [ "$(uname -s)" == "Linux" ]; then
    echo 'Supported OS YAY!' | tee -a $LOG_FILE
    OS_SUPPORTED=true
else
    echo 'Unsupported OS :(' | tee -a $LOG_FILE
    OS_SUPPORTED=false
    sleep 2
    exit 0
fi

if [ "$OS_SUPPORTED" == "true" ]; then
# Install PHP
    echo 'Installing Dependencies...' | tee -a $LOG_FILE
    sudo apt install -qq php php-cli php-fpm php-mysql php-pgsql php-xml php-mbstring php-curl php-zip php-gd php-json php-intl php-soap php-redis php-memcached php-xdebug php-openssl php-gmp php-bz2 php-tidy php-xmlrpc php-sybase php-sybase-ct php-mcrypt php-ldap php-exif php-fileinfo php-ffi -y
    loading
    echo 'Complete PHP Installation successfully' | tee -a $LOG_FILE

# MYSQL
    echo 'Installing MySQL, DO NOT TOUCH YOUR KEYBOARD...' | tee -a $LOG_FILE
    sudo apt install -qq -y mysql-server
    echo "Starting MySQL service..." | tee -a $LOG_FILE
    sudo systemctl start mysql
    loading
# Secure MySQL
    echo "Securing MySQL installation..." | tee -a $LOG_FILE
    sudo mysql_secure_installation <<EOF

Y
4+tcOGin7fVr14b9'MX1W$08D4W!1im8qlk
4+tcOGin7fVr14b9'MX1W$08D4W!1im8qlk
Y
Y
Y
Y
EOF

    echo 'MySQL secured successfully!' | tee -a $LOG_FILE
    echo 'Installing Surge Panel...' | tee -a $LOG_FILE
    countdown
else
    echo 'FATAL OS ERROR: TERMINATING'
    exit 0
fi

echo "How did you install the software? (Enter 'wget' or 'github')"
read method

if [[ "$method" == "curl" || "$method" == "wget" ]]; then
    echo "Pulling the latest changes from the GitHub repository..."
    git clone https://github.com/SurgePanel/SurgePanel.git
    sleep 4
    cd SurgePanel/
    bash ./deploy.sh

elif [[ "$method" == "github" ]]; then
    echo "Executing the script for GitHub clone installation..."
    chmod +x ./deploy.sh
    bash ./deploy.sh

else
    echo "Invalid input. Please enter 'wget' or 'github'."
    echo "Now wait 30 seconds cause you cant follow instructions, smh im disapointed"
    count_down
fi
# if you see this thats a problem!

exit 1
