#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Function to display help
usage() {
  echo "Usage: $0 --url <goerli_url> [--creds <creds_file>] [--auth]"
  exit 1
}

# Parse command-line arguments
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    --url)
    goerli_url="$2"
    shift
    shift
    ;;
    --creds)
    creds_file="$2"
    shift
    shift
    ;;
    --auth)
    auth="true"
    shift
    ;;
    *)
    usage
    ;;
  esac
done

# Check if Goerli URL is provided
if [ -z "$goerli_url" ]
then
  usage
fi

# Set default creds file name if not provided
if [ -z "$creds_file" ]
then
  creds_file="hubble-creds.json"
fi

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Add NVM to the user's shell environment
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.bashrc

# Enable NVM for the current shell session
source ~/.nvm/nvm.sh

# Change Node Version
nvm install 18.7.0

# Install PM2
npm install -g yarn pm2

# Add PM2 to the user's shell environment
echo 'export PATH="$PATH:$(yarn global bin)"' >> ~/.bashrc

# Clone Hub
git clone https://github.com/farcasterxyz/hubble.git

# Checkout Branch
cd hubble && git checkout @farcaster/hubble@1.0.18

# Build
yarn install && yarn build

# Create Identity
cd apps/hubble/ && yarn identity create

# Generate unique user/pass and save to file if --auth flag is provided
auth_flag=""
if [ "$auth" == "true" ]
then
  username=$(openssl rand -base64 128 | tr -dc 'a-zA-Z0-9!?,#-_@' | head -c128)
  password=$(openssl rand -base64 128 | tr -dc 'a-zA-Z0-9!?,#-_@' | head -c128)
  echo "{\"username\": \"$username\", \"password\": \"$password\"}" > "$SCRIPT_DIR/$creds_file"
  auth_flag="--rpc-auth $username:$password"
fi

# Start
pm2 start "yarn start -e $goerli_url -b /dns/testnet1.farcaster.xyz/tcp/2282 -n 2 $auth_flag" --name hubble

# Notify the user to reload their shell environment
echo "Please run 'source ~/.bashrc' or restart your shell to have NVM and PM2 available in your environment."