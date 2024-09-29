# Dotfiles

This repo contains my dotfiles.

## Getting started

Install GNU stow:

```sh
sudo apt install stow
```

Clone the repo:

```
git clone https://github.com/falfab/dotfiles.git ~/dotfiles
cd ~/dotfiles
git submodule update --init
```

Install the dotfiles:

```
stow nvim
```

