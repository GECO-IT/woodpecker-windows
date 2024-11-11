::
:: Woodpecker Boot Startup
::

:: With docker 20.10 => docker network error on boot

sleep 60
sc start docker
sleep 30
cd C:\ProgramData\woodpecker-docker
docker-compose.exe down
docker-compose.exe up -d
