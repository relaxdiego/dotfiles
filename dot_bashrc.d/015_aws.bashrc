# vi: ft=bash

# bash completion for AWS CLI
# Reference: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html#cli-command-completion-configure
if which aws_completer >/dev/null; then
    complete -C "$(which aws_completer)" aws
fi

# Let awscli prompt you for commands
# See: https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-parameters-prompting.html
#
# Type "aws a<ENTER>" to see this at work
export AWS_CLI_AUTO_PROMPT=${AWS_CLI_AUTO_PROMPT:-off}
