# Exports


## $EDITOR
Set your default editor in the commandline and options \
`export EDITOR="/usr/bin/vim +startinsert"`

## $PROMPT_COMMAND
Keep history from all tabs \
`export PROMPT_COMMAND='history -a'`

## $PS1, $CLICOLOR
Colour and style of your command prompt \
[Explanation of PS1](http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/) \
Online Editors
* [http://bashrcgenerator.com/](http://bashrcgenerator.com/)
* [http://linux-sxs.org/housekeeping/lscolors.html](http://linux-sxs.org/housekeeping/lscolors.html)
* [http://ezprompt.net/](http://ezprompt.net/)

My Fvourite configuration: \
`export PS1="\[\033[38;5;0m\]\[\033[48;5;15m\][\$?] \d \t \[$(tput sgr0)\]\[\033[38;5;15m\]\[\033[48;5;-1m\]\n\[$(tput sgr0)\]\[\033[38;5;0m\]\[\033[48;5;11m\] \u@\h\[$(tput bold)\] \[$(tput sgr0)\]\[\033[38;5;15m\]\[\033[48;5;2m\] \w \[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;0m\]\[\033[48;5;0m\] \[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]\\$\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;0m\] \[$(tput sgr0)\]"` \
Required
`export CLICOLOR=1`

