# syntax = docker/dockerfile:1
# escape=`

ARG DOCKER_REGISTRY
FROM ${DOCKER_REGISTRY}/woodpecker-windows-base:latest

SHELL ["cmd", "/S", "/C"]

LABEL maintainer="Geco-iT Team <contact@geco-it.fr>" `
      name="geco-it/woodpecker-windows-base-chocolatey" `
      vendor="Geco-iT"

# Install last Chocolatey (https://docs.chocolatey.org/en-us/choco/setup)
RUN powershell -Command `
      "Set-ExecutionPolicy Bypass -Scope Process -Force; `
       [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
       iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" `
    `
    # Configure
    && C:\\ProgramData\\chocolatey\\bin\\choco.exe config set cachelocation C:\\tmp\\cache && `
	   C:\\ProgramData\\chocolatey\\bin\\choco.exe install -y chocolatey-core.extension && `
	   rmdir /S /Q C:\tmp\cache

SHELL ["bash.exe", "-c"]
