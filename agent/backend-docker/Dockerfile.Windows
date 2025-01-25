# syntax = docker/dockerfile:1
# escape=`

FROM mcr.microsoft.com/windows/nanoserver:ltsc2022

# Busybox Unicode https://github.com/rmyorston/busybox-w32
ARG BUSYBOX_VERSION=busybox-w64u-FRP-5467-g9376eebd8.exe `
    BUSYBOX_VERSION_SHA256=a78891d1067c6cd36c9849754d7be0402aae1bc977758635c27911fd7c824f6b

# Woodpecker Windows Agent https://github.com/woodpecker-ci/woodpecker/tags
ARG WOODPECKER_AGENT_VERSION=v3.0.1 `
    WOODPECKER_AGENT_VERSION_SHA256=d4ef8e2fa94281bc1e369786030fe7d5afa70fff98ec613d60e4c795bfd8ac8b

LABEL maintainer="Geco-iT Team <contact@geco-it.fr>" `
      name="geco-it/woodpecker-agent" `
      vendor="Geco-iT"

SHELL ["cmd", "/S", "/C"]

USER ContainerAdministrator

# Install Busybox Unix Tools (https://github.com/rmyorston/busybox-w32)
RUN mkdir C:\bin && `
    curl -fSsLo /bin/busybox64u.exe https://frippery.org/files/busybox/%BUSYBOX_VERSION% && `
    /bin/busybox64u --install -s /bin && `
    /bin/echo "%BUSYBOX_VERSION_SHA256% /bin/busybox64u.exe" > SHA256SUM && `
    /bin/sha256sum -c SHA256SUM && `
    /bin/rm -f SHA256SUM

# Add C:\bin to System Path
RUN setx /m PATH "C:\\bin;%path%"

# Install Woodpecker Windows Agent
RUN mkdir C:\etc\ssl\certs `
          C:\etc\woodpecker && `
    curl -fSsLo woodpecker-agent.zip https://github.com/woodpecker-ci/woodpecker/releases/download/%WOODPECKER_AGENT_VERSION%/woodpecker-agent_windows_amd64.zip && `
    /bin/unzip -d /bin woodpecker-agent.zip && `
    /bin/echo "%WOODPECKER_AGENT_VERSION_SHA256% woodpecker-agent.zip" > SHA256SUM && `
    /bin/sha256sum -c SHA256SUM && `
    /bin/rm -f woodpecker-agent.zip SHA256SUM

# Internal setting do NOT change! Signals that woodpecker is running inside a container
ENV GODEBUG=netdns=go `
    WOODPECKER_IN_CONTAINER=true

EXPOSE 3000

HEALTHCHECK CMD ["/bin/woodpecker-agent", "ping"]
ENTRYPOINT ["/bin/woodpecker-agent"]
