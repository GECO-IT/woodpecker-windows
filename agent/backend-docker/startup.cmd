::
:: Woodpecker Boot Startup
::

:: With docker 20.10 => docker network error on boot

sleep 60
sc start docker
sleep 30
docker-compose.exe -f C:\ProgramData\woodpecker-docker\docker-compose.yml down
docker-compose.exe -f C:\ProgramData\woodpecker-docker\docker-compose.yml up -d
