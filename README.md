# Hubble QuickLauncher Script
Easily spin up a hubble instance in mere seconds with a quick script.

Based off the [launch docs](https://warpcast.notion.site/Set-up-Hubble-on-EC2-Public-23b4e81d8f604ca9bf8b68f4bb086042)
## Installation/Usage

### curl the launcher file
```bash
curl https://raw.githubusercontent.com/TheLDB/hubble-quicklaunch/main/hubble-launcher.sh -O
```

# Alternatively:
(use this if the curl operation didn't work, or if you're making a change and want to PR it)
### Clone the repo
```bash
git clone https://github.com/TheLDB/hubble-quicklaunch
```

### CD Into the directory
```bash
cd hubble-quicklaunch
```

### Make the script executable
```bash
sudo chmod +x ./hubble-launcher.sh
```

## Parameters

### ``--url`` - **Required**
Your Goerli testnet URL to connect to

### ``--auth`` - **Optional**
If enabled, will protect your Hubble instance with a 128 char user & 128 char password BasicAuth. 

### ``--creds`` - **Optional**
A file to store the credentials for your hub in, if using with --auth

"Usage: $0 --url <goerli_url> [--creds <creds_file>] [--auth]"

## Credits
- [ChatGPT](https://chat.openai.com)
- [OpenAI Playground w/ GPT-4 (i ran out of ChatGPT requests)](https://platform.openai.com/playground?mode=chat&model=gpt-4)
- [Sleep Deprivation](https://en.wikipedia.org/wiki/Sleep_deprivation)

## Things I want to add:
[] Compatability w/ secret vaults like HashiCorp Vault, AWS Secrets Manager, and more
[] Support for other OS' and providers. This is currently only tested on Ubuntu 22.04 on an AWS m5.large instance.