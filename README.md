# Dotfiles

To get started, clone the repository into `~/Developer/dotfiles` using SSH:

```zsh
git clone git@github.com:michaelbrusegard/dotfiles.git ~/Developer/dotfiles
```
> [!NOTE]  
> I also maintain a private repository with encrypted secrets that is added into the repository as a Nix flake. Directly copying the dotfiles will therefore most likely fail since it will fail to fetch the private repository.

## Nix Options

- [nixpkgs](https://mynixos.com/nixpkgs/options)
- [nix-darwin](https://mynixos.com/nix-darwin/options)
- [home-manager](https://mynixos.com/home-manager/options)

## NixOS

### Screenshots
![2025-04-26_15-07-56](https://github.com/user-attachments/assets/cd56268b-93b1-4bfd-9c1f-2a999428dd6e)


## Darwin

Before setting up MacOS, System Integrity Protection (SIP) needs to be partially disabled for the [yabai](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection) tiling window manager to work correctly.

1. Turn off the mac, then press and hold the power button until "Loading startup options" appears.
   Click Options, then click Continue.

2. In the menu bar, choose `Utilities`, then `Terminal`

3. Run this:

```zsh
csrutil enable --without fs --without debug --without nvram
```

### Installing apps & utilities using homebrew

```zsh
zsh ~/dotfiles/macos/scripts/brew.zsh
```

### Setting sensible system settings for MacOS

```zsh
zsh ~/dotfiles/macos/scripts/defaults.zsh
```

### Creating symlinks for the config files

```zsh
cd ~/dotfiles && /opt/homebrew/bin/stow macos
```

### Setup login items

```zsh
zsh ~/dotfiles/macos/scripts/login.zsh
```

### Screenshots

<img width="560" alt="WezTerm" src="https://github.com/user-attachments/assets/d6c99c89-f4d5-465a-9faa-3756c8105962">

<img width="560" alt="Neovim & Safari" src="https://github.com/user-attachments/assets/1bad8a88-f082-4d7f-9345-6744e1e2cc64">

<img width="560" alt="Desktop wallpaper" src="https://github.com/user-attachments/assets/43a9b48a-b2b5-4a69-8afe-fd166f0f5380">

My setup evolves over time, so the screenshots might not reflect the current state of my setup.

## Espresso (Ubuntu Server)

Espresso is my personal home server used for hosting various applications and services.

### Installing packages

```sh
sh ~/dotfiles/espresso/scripts/apt.sh
```

### Setting up symlinks

```sh
cd ~/dotfiles/espresso && stow --adopt -t ~ home && sudo stow --adopt -t /etc etc && stow --adopt -t /data data && git restore .
```

### Setup login items

```sh
sh ~/dotfiles/espresso/scripts/login.sh
```

## Inspiration…

- Andrey0189's [Nix Hyprland configuration](https://github.com/Andrey0189/nixos-config-reborn/tree/master/home-manager/modules/hyprland)
- Notusknot's [nix-dotfiles](https://github.com/notusknot/dotfiles-nix)
- Mathias Bynens and his [MacOS defaults](https://github.com/mathiasbynens/dotfiles/blob/main/.macos)
- Dries Vints and his [SSH script](https://github.com/driesvints/dotfiles/blob/main/ssh.sh)
- Antione Martin and his [GPG script](https://github.com/antoinemartin/create-gpg-key/blob/main/create_gpg_key.sh)
- Elliot's fast and beautiful [.zshrc prompt](https://github.com/dreamsofautonomy/zensh/blob/main/.zshrc)
- [Michael Bao's dotfiles](https://github.com/tcmmichaelb139/.dotfiles)
- [Josean Martinez's dotfiles](https://github.com/josean-dev/dev-environment-files)
- [TheBlueRuby's awesome Arch Linux setup](https://github.com/TheBlueRuby/dotfiles-arch)
- [XLNC](https://github.com/naveenkrdy)
