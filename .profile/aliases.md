# Aliases

## directory listing
Some of my favourite formats \
`alias goop="ls -aGoOp"` \
`alias ll="ls -l"`
`alias sortfiles="du -sm .[!.]* *| sort -n"`

## git
Pull before push \
`alias git-push="git pull --rebase && git push"` \
Jump to a default Git direcotry \
`alias git-home='cd /path/to/default/git/` \
Jump to an alternate Git direcotry
`alias git-alt='cd /path/to/alternate/git/'` \

## powershell
Start a powershell session\
*Note: [How to install PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos)*\
`alias cmd="powershell"` \
`alias cmd.exe="powershell"`


## webservers
Start a webserver at current directory\
**HTTP server:** \
`alias webhere="/usr/bin/Python -m SimpleHTTPServer"`\
**PHP server:** \
`alias phphere="/usr/bin/php -S localhost:8000"`
