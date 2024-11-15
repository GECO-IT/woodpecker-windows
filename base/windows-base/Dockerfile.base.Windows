# syntax = docker/dockerfile:1
# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Busybox Unicode https://github.com/rmyorston/busybox-w32
ARG BUSYBOX_VERSION=busybox-w64u-FRP-5467-g9376eebd8.exe `
    BUSYBOX_VERSION_SHA256=a78891d1067c6cd36c9849754d7be0402aae1bc977758635c27911fd7c824f6b

LABEL maintainer="Geco-iT Team <contact@geco-it.fr>" `
      name="geco-it/woodpecker-windows-base" `
      vendor="Geco-iT"

SHELL ["cmd", "/S", "/C"]

# Install Busybox Unix Tools (https://github.com/rmyorston/busybox-w32)
RUN mkdir C:\bin && `
    curl -fSsLo /bin/busybox64u.exe https://frippery.org/files/busybox/%BUSYBOX_VERSION% && `
    /bin/busybox64u --install -s /bin && `
    /bin/echo "%BUSYBOX_VERSION_SHA256% /bin/busybox64u.exe" > SHA256SUM && `
    /bin/sha256sum -c SHA256SUM && `
    /bin/rm -f SHA256SUM `
    `
    # Add C:\bin to System Path
    && setx /m PATH "C:\\bin;%path%"

SHELL ["bash.exe", "-c"]

ENTRYPOINT ["bash.exe"]
