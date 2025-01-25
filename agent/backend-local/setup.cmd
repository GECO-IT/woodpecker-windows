:: =================================================================
::
:: Install Woodpecker Agent - Backend Local
::

:: =================================================================
:: Global vars

:: path without space !
set WOODPECKER_AGENT_VERSION=v3.0.1

set SETUP_PATH="C:\ProgramData\woodpecker-local"
set SERVICE_NAME=woodpecker-agent
set WOODPECKER_SERVER="woodpecker.lan.xxxxx:39443"
set WOODPECKER_HOSTNAME="woodpecker-agentxxx"
set WOODPECKER_AGENT_SECRET="xxxxx"
:: > 1 matrix failed view issues #4362
set WOODPECKER_MAX_WORKFLOWS=1
:: filter: https://woodpecker-ci.org/docs/administration/agent-config#woodpecker_filter_labels
set WOODPECKER_FILTER_LABELS=""

set PLUGIN_GIT_VERSION=2.6.0

:: =================================================================
:: main()

:: Force remove old service
.\nssm.exe stop %SERVICE_NAME%
.\nssm.exe remove %SERVICE_NAME% confirm

:: Install basic unix tools
mkdir bin
curl -fSsLo ./bin/busybox64u.exe https://frippery.org/files/busybox/busybox64u.exe
.\bin\busybox64u.exe --install -s %SETUP_PATH%\bin
:: for /f "tokens=*" %%i in ('.\bin\busybox64u --list') do mklink %SETUP_PATH%\bin\%%i.exe %SETUP_PATH%\bin\busybox.exe

:: Add .\bin to System Path
rem setx /M PATH "%SETUP_PATH%\bin;%PATH%"
rem comment if we rerun it => so do it manual

:: Download Woodpecker Windows Agent
curl -fSLo ./woodpecker-agent.zip https://github.com/woodpecker-ci/woodpecker/releases/download/%WOODPECKER_AGENT_VERSION%/woodpecker-agent_windows_amd64.zip
.\bin\unzip.exe -o -d . ./woodpecker-agent.zip
.\bin\rm.exe -f ./woodpecker-agent.zip

:: Woodpecker service - https://nssm.cc/commands
.\nssm.exe install %SERVICE_NAME% "%SETUP_PATH%\woodpecker-agent.exe"

.\nssm.exe set %SERVICE_NAME% DisplayName "Geco-iT Woodpecker Agent"
.\nssm.exe set %SERVICE_NAME% Start SERVICE_DELAYED_AUTO_START
.\nssm.exe set %SERVICE_NAME% Description "Woodpecker Agent for Windows"

.\nssm.exe set %SERVICE_NAME% AppStopMethodConsole 10000
.\nssm.exe set %SERVICE_NAME% AppStopMethodWindow 10000
.\nssm.exe set %SERVICE_NAME% AppStopMethodThreads 10000

:: standard log in stderr
.\nssm.exe set %SERVICE_NAME% AppStderr "%SETUP_PATH%\woodpecker-log.txt"
.\nssm.exe set %SERVICE_NAME% AppStdoutCreationDisposition 2
.\nssm.exe set %SERVICE_NAME% AppStderrCreationDisposition 2

.\nssm.exe set %SERVICE_NAME% AppExit Default Restart
.\nssm.exe set %SERVICE_NAME% AppRestartDelay 1000
.\nssm.exe set %SERVICE_NAME% AppExit 0 Exit

.\nssm set %SERVICE_NAME% AppEnvironmentExtra ^
    WOODPECKER_AGENT_CONFIG_FILE=agent.conf ^
    WOODPECKER_BACKEND=local ^
    WOODPECKER_GRPC_SECURE=true ^
    WOODPECKER_GRPC_VERIFY=true ^
    WOODPECKER_LOG_LEVEL=info ^
    WOODPECKER_SERVER=%WOODPECKER_SERVER% ^
    WOODPECKER_MAX_WORKFLOWS=%WOODPECKER_MAX_WORKFLOWS% ^
    WOODPECKER_HOSTNAME=%WOODPECKER_HOSTNAME% ^
    WOODPECKER_AGENT_SECRET=%WOODPECKER_AGENT_SECRET% ^
    WOODPECKER_FILTER_LABELS=%WOODPECKER_FILTER_LABELS% ^
    WOODPECKER_DEBUG_PRETTY=false ^
    WOODPECKER_DEBUG_NOCOLOR=true
::  folder must exist too dangerous
::  WOODPECKER_BACKEND_LOCAL_TEMP_DIR=C:\tmp\woodpecker ^

:: Start Woodpecker service
.\nssm.exe start %SERVICE_NAME%

::
:: Plugins
::

:: Install plugins
curl -fSLo ./bin/plugin-git.exe https://github.com/woodpecker-ci/plugin-git/releases/download/%PLUGIN_GIT_VERSION%/windows-amd64_plugin-git.exe

exit /B 0
