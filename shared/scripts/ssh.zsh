#!/usr/bin/env zsh

set -e  # Abort the script if any command fails

printf "Enter user email: "
read USER_EMAIL

echo "Using user email $USER_EMAIL"

# Generating a new SSH key (https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
ssh-keygen -t ed25519 -C "${USER_EMAIL}" -f ~/.ssh/github

# Adding your SSH key to the ssh-agent (https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent)
eval "$(ssh-agent -s)"

ssh-add --apple-use-keychain ~/.ssh/github

# Adding your SSH key to your GitHub account (https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account)
pbcopy < ~/.ssh/github.pub
echo "The SSH key has been copied to the clipboard."
echo "Please go to your GitHub account settings and add the SSH key."
echo "Opening link in 5 seconds..."

sleep 5

open "https://github.com/settings/keys"
