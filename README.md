Mark Maglana's Dotfiles
=======================

Automates the configuration of Vim, Tmux/BYOBU, and friends for make benefit
of glorious `$HOME`, life embetterment, great success, and world peace!


## Install `chezmoi`

Because we're fancy like that 'round these parts.
See https://www.chezmoi.io/docs/install/


## Initialize and Apply

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
