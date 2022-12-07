# vi: ft=bash

# bash completion for AWS CLI
# Reference: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html#cli-command-completion-configure
if which aws_completer >/dev/null; then
    complete -C "$(which aws_completer)" aws
fi
