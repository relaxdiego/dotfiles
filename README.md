Mark Maglana's Dotfiles
=======================

Automates the configuration of Vim, Tmux/BYOBU, and friends for make benefit
of glorious `$HOME`, life embetterment, great success, and world peace!

<p align="center">
  Ubuntu Setup
  <img src="https://raw.githubusercontent.com/relaxdiego/dotfiles/main/screenshot-ubuntu.png">
  MacOS Setup
  <img src="https://raw.githubusercontent.com/relaxdiego/dotfiles/main/screenshot-macos.png">
</p>

## Install `op`

I use 1Password to store secrets used by this repo. You'll need to install the
`op` CLI utility as specified here https://support.1password.com/command-line-getting-started

Then run

```
eval $(op signin <subdomain>.1password.com <email>)
```


## Install the Ubuntu Mono Nerd Font

Ubunto Mono?! Where we're going, we don't need [just] Ubunto Mono.
[Get its Nerd Font equivalent](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip)
and use it on your terminal.


## Install `chezmoi`

Because we're fancy like that 'round these parts.
See https://www.chezmoi.io/docs/install/


## Initialize and Apply

NOTE: In all of the `init` subcommands below, the dotfiles repo will be cloned
      to `~/.local/share/chezmoi`

#### YOLO Mode

```
eval $(op signin) && chezmoi init --apply --verbose https://github.com/relaxdiego/dotfiles.git
```

#### Responsible Adult Mode

```
eval $(op signin) && chezmoi init https://github.com/relaxdiego/dotfiles.git
chezmoi diff
```

If you're happy with what you see, run:

```
chezmoi apply -v
```


## Update to the Latest Changes

#### YOLO Mode

```
eval $(op signin) && chezmoi update -v
```

#### Responsible Adult Mode

```
eval $(op signin) && chezmoi source pull -- --rebase && chezmoi diff
```

If you're happy with the changes, run:

```
chezmoi apply
```
