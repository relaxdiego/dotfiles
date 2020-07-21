Mark Maglana's Dotfiles
=======================

Automates the configuration of Vim, Tmux/BYOBU, and friends for make benefit
of glorious `$HOME`, life embetterment, great success, and world peace!


## Install `op`

I use 1Password to store secrets used by this repo. You'll need to install the
`op` CLI utility as specified here https://support.1password.com/command-line-getting-started

Then run

```
eval $(op signin <subdomain>.1password.com <email>)
```


## Install `chezmoi`

Because we're fancy like that 'round these parts.
See https://www.chezmoi.io/docs/install/


## Initialize and Apply

NOTE: In all of the `init` subcommands below, the dotfiles repo will be cloned
      to `~/.local/share/chezmoi

### YOLO Mode

```
chezmoi init --apply --verbose https://github.com/relaxdiego/dotfiles.git
```

### Responsible Adult Mode

```
chezmoi init https://github.com/relaxdiego/dotfiles.git
chezmoi diff
```

If you're happy with what you see, run:

```
chezmoi apply -v
```


## Update to the Latest Changes

### YOLO Mode

```
chezmoi update -v
```

### Responsible Adult Mode

```
chezmoi source pull -- --rebase && chezmoi diff
```

If you're happy with the changes, run:

```
chezmoi apply
```
