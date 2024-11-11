::
:: Woodpecker: Docker Clean Cron
::

:: Remove all stopped containers
for /f "tokens=*" %%i in ('docker ps --filter "status=exited" -q') do docker rm %%i

:: Remove all unused images
for /f "tokens=*" %%i in ('docker images --filter "dangling=true" -q --no-trunc') do docker image rm %%i

:: Remove Woodpecker Volumes
for /f "tokens=*" %%i in ('docker volume ls --filter "name=^wp_*" --filter "dangling=true" -q') do docker volume rm %%i