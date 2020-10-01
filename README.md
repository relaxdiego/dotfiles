<p align="center">
  <img src="https://raw.githubusercontent.com/relaxdiego/dotfiles/main/logo.png">
</p>


# Mark Maglana's Dotfiles

Automates the configuration of Vim, Tmux/BYOBU, and friends for make benefit
of glorious `$HOME`, life embetterment, great success, and world peace!

<p align="center">
  Ubuntu Setup
  <img src="https://raw.githubusercontent.com/relaxdiego/dotfiles/main/screenshot-ubuntu.png">
  MacOS Setup
  <img src="https://raw.githubusercontent.com/relaxdiego/dotfiles/main/screenshot-macos.png">
</p>


## WARNING: I Assume This Is Running On A Newly Installed OS

The first time I run the commands below is right after a fresh OS install,
so this will overwrite a few pre-existing files if it's already there. For
example: `~/.bashrc` and `~/.vimrc`. So please make sure to have a backup
of your home directory if you're installing this on a brownfield system.


## Swap Your `Ctrl` and `Caps Lock` Keys!

You gotta trust me on this one. If you want to be productive in the terminal,
you will want to keep your fingers in the home row (that row with the A, 
S, D, and F keys) as much as possible. This will allow you to perform your key combos
faster, reduce mental friction, and speed up muscle memory building.

While we're at it, stop using the arrow keys and learn to use H, J, K, and L
for navigation because this is more transferable knowledge. For example, moving
between vim windows uses [Ctrl]-{h,j,k,l}, moving between tmux/byobu panes uses
[Ctrl]-a {h,j,k,l}, resizing tmux panes uses [Ctrl-a] [Shift]-{h,j,k,l}, and
a whole lot more! Your perceived productivity might take a slight dip for a few
days or weeks, but once the muscle memory has sunk in, you will regain what you
have lost tenfold and will be happier and more comfortable in the terminal.

Remember: The home row is where the art of terminal productivity is!

## Install `op`

NOTE: If you're installing these dotfiles in a shared machine, you may
      skip this section.

I use 1Password to store secrets used by this repo. You'll need to install the
`op` CLI utility. [Get it here](https://1password.com/downloads/command-line/).

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
chezmoi init --apply https://github.com/relaxdiego/dotfiles.git
```

#### Responsible Adult Mode

```
chezmoi init https://github.com/relaxdiego/dotfiles.git
chezmoi diff
```

If you're happy with what you see, run:

```
chezmoi apply
```


## Update to the Latest Changes

#### YOLO Mode

```
chezmoi update
```

#### Responsible Adult Mode

```
chezmoi source pull -- --rebase && chezmoi diff
```

If you're happy with the changes, run:

```
chezmoi apply
```

## Troubleshooting

#### [ERROR] session expired

This is 1Password telling you that you need to sign in again. So run:

```
eval $(op signin)
```

And then re-run the `chezmoi` command you were trying to run beforehand.


### chezmoi: template:...map has no entry for key "[somekeyhere]"

This means I've added a new key in `.chezmoi.toml.tmpl` and now you
have the enviable task of re-initializing your dotfiles! Run:

```
chezmoi init
```

Then re-run the `chezmoi` command you were trying to run beforehand.
