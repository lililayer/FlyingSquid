cd Resources/ServerDirectory/

#echo 'Creating virtual environement (sea)...'
#python3 -m venv sea
#echo 'Starting sea...'
#source ... too busy for now

echo 'starting the server...'
gnome-terminal  --title='SEA' -- bash -c "python3 -m http.server 27015 --directory ./"
