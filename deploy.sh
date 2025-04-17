#!/bin/bash/

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

loading
echo 'For Real this time: Finalising Configs'
sleep 1
echo "Please enter the port number for the PHP application: "
read PORT

if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
    echo "Error: Invalid port number. Please enter a number between 1 and 65535."
    exit 1
fi
loading
echo "Your PHP server is running on port: $PORT"
echo 'This will now turn into a console output for PHP'
sleep 1
php -S localhost:$PORT -t ./web/