# syntax = docker/dockerfile:1
# escape=`

ARG DOCKER_REGISTRY
FROM ${DOCKER_REGISTRY}/woodpecker-windows-base-chocolatey:latest

LABEL maintainer="Geco-iT Team <contact@geco-it.fr>" `
      name="geco-it/woodpecker-windows-base-chocolatey-msvsbuild" `
      vendor="Geco-iT"

SHELL ["cmd", "/S", "/C"]

# Visual Studio 2022 Build Tools (https://learn.microsoft.com/fr-fr/visualstudio/install/build-tools-container?view=vs-2022)
ARG VS_BUILD_TOOLS_URL=https://aka.ms/vs/17/release/vs_buildtools.exe
RUN curl -fSsLo vs_buildtools.exe "%VS_BUILD_TOOLS_URL%" && `
    (start /w vs_buildtools.exe --quiet --wait --norestart --nocache `
        --installPath C:\Microsoft-Visual-Studio\2022\BuildTools `
        --add Microsoft.VisualStudio.Workload.VCTools `
        --add Microsoft.VisualStudio.Workload.MSBuildTools `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
        --remove Microsoft.VisualStudio.Component.Windows81SDK `
        || if "%ERRORLEVEL%"=="3010" exit 0) `
    `
    # Cleanup
    && del /q vs_buildtools.exe

SHELL ["bash.exe", "-c"]
