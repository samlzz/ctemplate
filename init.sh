#!/bin/bash

echo -n "Which shell do you use? (bash/zsh/fish/other) [bash]:"
read -r shell

case "$shell" in
    bash)
        config_file="$HOME/.bashrc"
        ;;
    zsh)
        config_file="$HOME/.zshrc"
        ;;
    fish)
        config_file="$HOME/.config/fish/config.fish"
        ;;
    other)
        echo "Please enter the path to your configuration file:"
        read -r config_file
        ;;
    *)
        echo "Unrecognized shell. Please specify 'other' when prompted for your shell."
        exit 1
        ;;
esac

if [ ! -f "$config_file" ]; then
    echo "Configuration file not found: $config_file"
    exit 1
fi

cat ./utils.sh >> "$config_file"
echo "Successfully configured 'utils.sh' functions'