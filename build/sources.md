# Build agent from source

* Documentation: <https://woodpecker-ci.org/docs/development/getting-started>

## Build agent from PR

```bash
git clone https://github.com/6543-forks/woodpecker.git
git checkout make-windows-container-work-again
docker run -ti -v ${PWD}/pull4286:/src debian:bookworm

# install prereq
apt update
apt install wget make git joe patch zip
cd /src/woodpecker
git config --global --add safe.directory /src/woodpecker
wget https://go.dev/dl/go1.23.3.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# build all agent
#export CI_COMMIT_TAG=2.7.3
make release-agent
ls -l ./dist
```
