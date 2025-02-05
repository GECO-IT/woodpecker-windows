# syntax = docker/dockerfile:1
# escape=`

ARG DOCKER_REGISTRY
FROM ${DOCKER_REGISTRY}/woodpecker-windows-base-chocolatey-msvsbuild:latest

ARG PYTHON_VERSION=311

LABEL maintainer="Geco-iT Team <contact@geco-it.fr>" `
      name="geco-it/woodpecker-windows-python" `
      vendor="Geco-iT"

SHELL ["cmd", "/S", "/C"]

# Install Python
RUN choco install -y python%PYTHON_VERSION% --params "/InstallDir:C:\Python /NoLockdown" && `
    rmdir /S /Q C:\tmp\cache

# Upgrade
RUN python.exe -m pip install --no-cache-dir --upgrade pip && `
    pip install --no-cache-dir --upgrade setuptools

SHELL ["bash.exe", "-c"]
