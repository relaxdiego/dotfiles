# vi: ft=bash

# Pre-warm gpg-agent: force the passphrase prompt now so the key is cached
# for the session (see ~/.gnupg/gpg-agent.conf for the cache TTL). Run this
# before launching a TUI such as LazyGit or Neovim so the pinentry prompt
# does not pop up and disrupt the TUI later.
#
# If the key is already cached, this returns instantly without prompting.
gpg-unlock() {
    if echo "gpg-unlock" | gpg --clearsign --output /dev/null; then
        echo "GPG key unlocked. It stays cached for the session."
    else
        echo "GPG unlock failed." >&2
        return 1
    fi
}
