# Debian's /etc/profile rebuilds PATH from scratch in every login shell.
# /etc/profile.d/nix.sh would put nix's bin dirs back, but it returns early
# when __ETC_PROFILE_NIX_SOURCED is already exported by a parent process. So
# nested login shells (a tmux pane, ssh, `bash -l`) silently lose nix, and
# anything that shells out to it (devbox, direnv) fails with "we found a /nix
# directory but nix binary is not in your PATH".
for _nix_bin in "$HOME/.nix-profile/bin" /nix/var/nix/profiles/default/bin; do
    if [ -d "$_nix_bin" ]; then
        case ":$PATH:" in
            *":$_nix_bin:"*) ;;
            *) PATH="$_nix_bin:$PATH" ;;
        esac
    fi
done
unset _nix_bin
export PATH
