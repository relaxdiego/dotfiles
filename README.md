My Dotfiles
===========

Automates the setup of Vim, Tmux, and friends for life embetterment and
world peace!

Requirements for MacOS
----------------------

1. brew install pyenv
2. brew install openssl
3. brew install wget
4. brew install go
5. CFLAGS="-I$(brew --prefix openssl)/include" LDFLAGS="-L$(brew --prefix openssl)/lib" pyenv install -v 2.7.14
6. brew install vim

Installation
------------

1. Clone this repo 
2. cd to your clone
3. Run `./setup`
4. Install missing dependencies if any
5. Profit!


Fixes
------------
*In case YouCompleteMe fails to compile:
 1. Install the latest cmake & gcc using homebrew
 2. Check that $HOME/.vmrc is symlinked to this repo's vim/vimrc (or copy the file)
 3. Add 'set encoding=utf-8' to your .vimrc file
 4. Run `./setup`
 5. Profit!

Quickly Get Started in AWS!
---------------------------

Check out my other project https://github.com/relaxdiego/jumpbox
